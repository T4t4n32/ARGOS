#include <Arduino.h>
#include <Wire.h>
#include <math.h>

#ifndef M_PI
#define M_PI 3.14159265358979323846
#endif

// =======================================================
// CONFIGURACIÓN GENERAL
// =======================================================

static const uint32_t SERIAL_BAUD = 115200;
static const uint32_t I2C_SPEED   = 100000UL;

// Direcciones posibles
static const uint8_t MPU_ADDR_1 = 0x68;
static const uint8_t MPU_ADDR_2 = 0x69;

static const uint8_t ENV_ADDR_1 = 0x76;
static const uint8_t ENV_ADDR_2 = 0x77;

// Registros MPU6050
static const uint8_t MPU_WHO_AM_I     = 0x75;
static const uint8_t MPU_PWR_MGMT_1   = 0x6B;
static const uint8_t MPU_SMPLRT_DIV   = 0x19;
static const uint8_t MPU_CONFIG       = 0x1A;
static const uint8_t MPU_GYRO_CONFIG  = 0x1B;
static const uint8_t MPU_ACCEL_CONFIG = 0x1C;
static const uint8_t MPU_ACCEL_XOUT_H = 0x3B;

// Registros BME/BMP280
static const uint8_t ENV_ID_REG       = 0xD0;
static const uint8_t ENV_RESET_REG    = 0xE0;
static const uint8_t ENV_CTRL_HUM     = 0xF2;
static const uint8_t ENV_STATUS       = 0xF3;
static const uint8_t ENV_CTRL_MEAS    = 0xF4;
static const uint8_t ENV_CONFIG       = 0xF5;
static const uint8_t ENV_DATA_START   = 0xF7;

static const uint8_t CHIP_ID_BMP280 = 0x58;
static const uint8_t CHIP_ID_BME280 = 0x60;

uint8_t mpuAddr = 0;
uint8_t envAddr = 0;
uint8_t envChipId = 0;

bool mpuOK = false;
bool envOK = false;
bool envIsBME280 = false;

// =======================================================
// FUNCIONES I2C BÁSICAS
// =======================================================

bool write8(uint8_t address, uint8_t reg, uint8_t value) {
  Wire.beginTransmission(address);
  Wire.write(reg);
  Wire.write(value);
  return Wire.endTransmission() == 0;
}

bool read8(uint8_t address, uint8_t reg, uint8_t &value) {
  Wire.beginTransmission(address);
  Wire.write(reg);

  if (Wire.endTransmission(false) != 0) {
    return false;
  }

  if (Wire.requestFrom(address, (uint8_t)1) != 1) {
    return false;
  }

  value = Wire.read();
  return true;
}

bool readBytes(uint8_t address, uint8_t reg, uint8_t *buffer, uint8_t length) {
  Wire.beginTransmission(address);
  Wire.write(reg);

  if (Wire.endTransmission(false) != 0) {
    return false;
  }

  uint8_t received = Wire.requestFrom(address, length);

  if (received != length) {
    return false;
  }

  for (uint8_t i = 0; i < length; i++) {
    buffer[i] = Wire.read();
  }

  return true;
}

uint16_t u16LE(const uint8_t *b) {
  return (uint16_t)b[0] | ((uint16_t)b[1] << 8);
}

int16_t s16LE(const uint8_t *b) {
  return (int16_t)((uint16_t)b[0] | ((uint16_t)b[1] << 8));
}

int16_t signExtend12(uint16_t value) {
  if (value & 0x0800) {
    value |= 0xF000;
  }
  return (int16_t)value;
}

// =======================================================
// MPU6050
// =======================================================

bool beginMPU6050() {
  uint8_t candidates[2] = {MPU_ADDR_1, MPU_ADDR_2};

  for (uint8_t i = 0; i < 2; i++) {
    uint8_t who = 0;
    uint8_t addr = candidates[i];

    if (read8(addr, MPU_WHO_AM_I, who)) {
      if ((who & 0x7E) == 0x68) {
        mpuAddr = addr;

        // Despertar MPU6050
        write8(mpuAddr, MPU_PWR_MGMT_1, 0x00);
        delay(100);

        // Sample rate: 1 kHz / (1 + 7) = 125 Hz
        write8(mpuAddr, MPU_SMPLRT_DIV, 0x07);

        // Filtro DLPF
        write8(mpuAddr, MPU_CONFIG, 0x03);

        // Giroscopio ±250 °/s
        write8(mpuAddr, MPU_GYRO_CONFIG, 0x00);

        // Acelerómetro ±2g
        write8(mpuAddr, MPU_ACCEL_CONFIG, 0x00);

        return true;
      }
    }
  }

  return false;
}

bool readMPU6050() {
  uint8_t data[14];

  if (!readBytes(mpuAddr, MPU_ACCEL_XOUT_H, data, 14)) {
    return false;
  }

  int16_t rawAX = ((int16_t)data[0] << 8) | data[1];
  int16_t rawAY = ((int16_t)data[2] << 8) | data[3];
  int16_t rawAZ = ((int16_t)data[4] << 8) | data[5];

  int16_t rawTemp = ((int16_t)data[6] << 8) | data[7];

  int16_t rawGX = ((int16_t)data[8] << 8) | data[9];
  int16_t rawGY = ((int16_t)data[10] << 8) | data[11];
  int16_t rawGZ = ((int16_t)data[12] << 8) | data[13];

  // Escalas configuradas:
  // Acelerómetro ±2g -> 16384 LSB/g
  // Giroscopio ±250 dps -> 131 LSB/(°/s)
  float ax = rawAX / 16384.0;
  float ay = rawAY / 16384.0;
  float az = rawAZ / 16384.0;

  float gx = rawGX / 131.0;
  float gy = rawGY / 131.0;
  float gz = rawGZ / 131.0;

  float imuTemp = (rawTemp / 340.0) + 36.53;

  // Ángulos básicos aproximados usando acelerómetro
  float roll  = atan2(ay, az) * 180.0 / M_PI;
  float pitch = atan2(-ax, sqrt((ay * ay) + (az * az))) * 180.0 / M_PI;

  Serial.println(F("===== MPU6050 / IMU ====="));

  Serial.print(F("Accel[g]  X: "));
  Serial.print(ax, 3);
  Serial.print(F("  Y: "));
  Serial.print(ay, 3);
  Serial.print(F("  Z: "));
  Serial.println(az, 3);

  Serial.print(F("Gyro[dps] X: "));
  Serial.print(gx, 2);
  Serial.print(F("  Y: "));
  Serial.print(gy, 2);
  Serial.print(F("  Z: "));
  Serial.println(gz, 2);

  Serial.print(F("Roll: "));
  Serial.print(roll, 2);
  Serial.print(F(" deg  Pitch: "));
  Serial.print(pitch, 2);
  Serial.println(F(" deg"));

  Serial.print(F("Temp IMU: "));
  Serial.print(imuTemp, 2);
  Serial.println(F(" C"));

  return true;
}

// =======================================================
// BME280 / BMP280
// =======================================================

struct EnvCalibration {
  uint16_t dig_T1;
  int16_t  dig_T2;
  int16_t  dig_T3;

  uint16_t dig_P1;
  int16_t  dig_P2;
  int16_t  dig_P3;
  int16_t  dig_P4;
  int16_t  dig_P5;
  int16_t  dig_P6;
  int16_t  dig_P7;
  int16_t  dig_P8;
  int16_t  dig_P9;

  uint8_t  dig_H1;
  int16_t  dig_H2;
  uint8_t  dig_H3;
  int16_t  dig_H4;
  int16_t  dig_H5;
  int8_t   dig_H6;
};

EnvCalibration cal;
int32_t tFine = 0;

bool readEnvCalibration() {
  uint8_t c1[26];

  if (!readBytes(envAddr, 0x88, c1, 26)) {
    return false;
  }

  cal.dig_T1 = u16LE(&c1[0]);
  cal.dig_T2 = s16LE(&c1[2]);
  cal.dig_T3 = s16LE(&c1[4]);

  cal.dig_P1 = u16LE(&c1[6]);
  cal.dig_P2 = s16LE(&c1[8]);
  cal.dig_P3 = s16LE(&c1[10]);
  cal.dig_P4 = s16LE(&c1[12]);
  cal.dig_P5 = s16LE(&c1[14]);
  cal.dig_P6 = s16LE(&c1[16]);
  cal.dig_P7 = s16LE(&c1[18]);
  cal.dig_P8 = s16LE(&c1[20]);
  cal.dig_P9 = s16LE(&c1[22]);

  cal.dig_H1 = c1[25];

  if (envIsBME280) {
    uint8_t h[7];

    if (!readBytes(envAddr, 0xE1, h, 7)) {
      return false;
    }

    cal.dig_H2 = s16LE(&h[0]);
    cal.dig_H3 = h[2];

    uint16_t h4Raw = ((uint16_t)h[3] << 4) | (h[4] & 0x0F);
    uint16_t h5Raw = ((uint16_t)h[5] << 4) | (h[4] >> 4);

    cal.dig_H4 = signExtend12(h4Raw);
    cal.dig_H5 = signExtend12(h5Raw);
    cal.dig_H6 = (int8_t)h[6];
  }

  return true;
}

int32_t compensateTemperature(int32_t adcT) {
  int32_t var1;
  int32_t var2;
  int32_t temperature;

  var1 = ((((adcT >> 3) - ((int32_t)cal.dig_T1 << 1))) *
          ((int32_t)cal.dig_T2)) >> 11;

  var2 = (((((adcT >> 4) - ((int32_t)cal.dig_T1)) *
            ((adcT >> 4) - ((int32_t)cal.dig_T1))) >> 12) *
          ((int32_t)cal.dig_T3)) >> 14;

  tFine = var1 + var2;

  temperature = (tFine * 5 + 128) >> 8;

  // Devuelve temperatura en °C * 100
  return temperature;
}

uint32_t compensatePressure(int32_t adcP) {
  int64_t var1;
  int64_t var2;
  int64_t p;

  var1 = ((int64_t)tFine) - 128000;
  var2 = var1 * var1 * (int64_t)cal.dig_P6;
  var2 = var2 + ((var1 * (int64_t)cal.dig_P5) << 17);
  var2 = var2 + (((int64_t)cal.dig_P4) << 35);

  var1 = ((var1 * var1 * (int64_t)cal.dig_P3) >> 8) +
         ((var1 * (int64_t)cal.dig_P2) << 12);

  var1 = (((((int64_t)1) << 47) + var1)) *
         ((int64_t)cal.dig_P1) >> 33;

  if (var1 == 0) {
    return 0;
  }

  p = 1048576 - adcP;
  p = (((p << 31) - var2) * 3125) / var1;

  var1 = (((int64_t)cal.dig_P9) * (p >> 13) * (p >> 13)) >> 25;
  var2 = (((int64_t)cal.dig_P8) * p) >> 19;

  p = ((p + var1 + var2) >> 8) + (((int64_t)cal.dig_P7) << 4);

  // Devuelve presión en Pa * 256
  return (uint32_t)p;
}

uint32_t compensateHumidity(int32_t adcH) {
  int32_t v;

  v = tFine - 76800;

  v = (((((adcH << 14) -
          (((int32_t)cal.dig_H4) << 20) -
          (((int32_t)cal.dig_H5) * v)) + 16384) >> 15) *
       (((((((v * ((int32_t)cal.dig_H6)) >> 10) *
             (((v * ((int32_t)cal.dig_H3)) >> 11) + 32768)) >> 10) +
           2097152) *
          ((int32_t)cal.dig_H2) + 8192) >> 14));

  v = v - (((((v >> 15) * (v >> 15)) >> 7) *
            ((int32_t)cal.dig_H1)) >> 4);

  if (v < 0) {
    v = 0;
  }

  if (v > 419430400) {
    v = 419430400;
  }

  // Devuelve humedad relativa en % * 1024
  return (uint32_t)(v >> 12);
}

bool beginEnvSensor() {
  uint8_t candidates[2] = {ENV_ADDR_1, ENV_ADDR_2};

  for (uint8_t i = 0; i < 2; i++) {
    uint8_t addr = candidates[i];
    uint8_t id = 0;

    if (read8(addr, ENV_ID_REG, id)) {
      if (id == CHIP_ID_BME280 || id == CHIP_ID_BMP280) {
        envAddr = addr;
        envChipId = id;
        envIsBME280 = (id == CHIP_ID_BME280);

        // Reset suave
        write8(envAddr, ENV_RESET_REG, 0xB6);
        delay(100);

        if (!readEnvCalibration()) {
          return false;
        }

        // BME280: activar humedad x1
        if (envIsBME280) {
          write8(envAddr, ENV_CTRL_HUM, 0x01);
        }

        // Config sin filtro, standby corto
        write8(envAddr, ENV_CONFIG, 0x00);

        // Temperatura x1, presión x1, modo normal
        // osrs_t = 001, osrs_p = 001, mode = 11
        write8(envAddr, ENV_CTRL_MEAS, 0x27);

        return true;
      }
    }
  }

  return false;
}

bool readEnvSensor() {
  uint8_t data[8];

  uint8_t length = envIsBME280 ? 8 : 6;

  if (!readBytes(envAddr, ENV_DATA_START, data, length)) {
    return false;
  }

  int32_t adcP = ((int32_t)data[0] << 12) |
                 ((int32_t)data[1] << 4) |
                 ((int32_t)data[2] >> 4);

  int32_t adcT = ((int32_t)data[3] << 12) |
                 ((int32_t)data[4] << 4) |
                 ((int32_t)data[5] >> 4);

  int32_t adcH = 0;

  if (envIsBME280) {
    adcH = ((int32_t)data[6] << 8) | data[7];
  }

  int32_t tempC100 = compensateTemperature(adcT);
  uint32_t pressurePa256 = compensatePressure(adcP);

  float temperatureC = tempC100 / 100.0;
  float pressurePa = pressurePa256 / 256.0;
  float pressurehPa = pressurePa / 100.0;

  Serial.println(F("===== BME/BMP280 ====="));

  Serial.print(F("Sensor: "));
  if (envIsBME280) {
    Serial.println(F("BME280"));
  } else {
    Serial.println(F("BMP280"));
  }

  Serial.print(F("Temp ambiente: "));
  Serial.print(temperatureC, 2);
  Serial.println(F(" C"));

  Serial.print(F("Presion: "));
  Serial.print(pressurehPa, 2);
  Serial.println(F(" hPa"));

  if (envIsBME280) {
    uint32_t humidity1024 = compensateHumidity(adcH);
    float humidity = humidity1024 / 1024.0;

    Serial.print(F("Humedad: "));
    Serial.print(humidity, 2);
    Serial.println(F(" %"));
  } else {
    Serial.println(F("Humedad: no disponible en BMP280"));
  }

  return true;
}

// =======================================================
// SETUP Y LOOP
// =======================================================

void setup() {
  Serial.begin(SERIAL_BAUD);
  delay(1000);

  Wire.begin();
  Wire.setClock(I2C_SPEED);

  Serial.println();
  Serial.println(F("==================================="));
  Serial.println(F(" Arduino UNO + HW-290 + BME/BMP280"));
  Serial.println(F(" PlatformIO - Lectura por I2C"));
  Serial.println(F("==================================="));

  mpuOK = beginMPU6050();

  if (mpuOK) {
    Serial.print(F("MPU6050 detectado en 0x"));
    Serial.println(mpuAddr, HEX);
  } else {
    Serial.println(F("ERROR: No se detecto MPU6050 en 0x68/0x69"));
  }

  envOK = beginEnvSensor();

  if (envOK) {
    Serial.print(F("Sensor ambiental detectado en 0x"));
    Serial.print(envAddr, HEX);
    Serial.print(F(" con ID 0x"));
    Serial.println(envChipId, HEX);
  } else {
    Serial.println(F("ERROR: No se detecto BME280/BMP280 en 0x76/0x77"));
  }

  Serial.println();
}

void loop() {
  Serial.println(F("-----------------------------------"));

  if (mpuOK) {
    if (!readMPU6050()) {
      Serial.println(F("ERROR leyendo MPU6050"));
    }
  } else {
    Serial.println(F("MPU6050 no inicializado"));
  }

  Serial.println();

  if (envOK) {
    if (!readEnvSensor()) {
      Serial.println(F("ERROR leyendo BME/BMP280"));
    }
  } else {
    Serial.println(F("BME/BMP280 no inicializado"));
  }

  Serial.println(F("-----------------------------------"));
  Serial.println();

  delay(1000);
}