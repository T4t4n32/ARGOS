#include <RadioLib.h>

// SX1278 (Ra-02) Pinout
SX1278 lora = new Module(5, 26, 14, -1);

void setup() {
  Serial.begin(115200);
  delay(2000);

  Serial.println("[TX] Initializing LoRa...");

  int state = lora.begin(433.0);
  if (state != RADIOLIB_ERR_NONE) {
    Serial.print("[TX] LoRa init failed, code ");
    Serial.println(state);
    while (true);
  }

  Serial.println("[TX] LoRa init OK.");
  Serial.println("[TX] Operating in MODEM mode: Serial-to-LoRa Bridge Active.");
}

void loop() {
  // Escuchar a la Raspberry Pi a través del puerto Serial (USB/UART)
  if (Serial.available() > 0) {
    String payload = Serial.readStringUntil('\n');
    payload.trim();

    if (payload.length() > 0) {
      Serial.print("[TX] Transmitting: ");
      Serial.println(payload);

      // Transmitir la cadena exacta que llegó de la Pi
      int state = lora.transmit(payload);
      
      if (state == RADIOLIB_ERR_NONE) {
        Serial.println("[TX] Sent OK");
      } else {
        Serial.print("[TX] Send failed, code ");
        Serial.println(state);
      }
    }
  }
}
