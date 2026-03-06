// TX - Heltec Wireless Stick V3 (SX1262) - RadioLib
#include <RadioLib.h>

// pines (tal como en la doc de Heltec)
SX1262 lora = new Module(8, 14, 12, 13); // NSS, DIO1, NRST, BUSY

// Pin del pulsador
#define BUTTON_PIN 4  

void setup() {
  Serial.begin(115200);
  delay(2000);

  pinMode(BUTTON_PIN, INPUT_PULLUP); 

  Serial.println("[TX] Inicializando LoRa...");

  int state = lora.begin(433.0); 
  if (state != RADIOLIB_ERR_NONE) {
    Serial.print("[TX] Fallo inicializando LoRa, codigo: ");
    Serial.println(state);
    while(true);
  }

  Serial.println("[TX] LoRa OK");
}

void loop() {
  // Cuando se presiona el botón (LOW)
  if (digitalRead(BUTTON_PIN) == LOW) {
    String mensaje = "Boton presionado!";
    Serial.print("[TX] Enviando: ");
    Serial.println(mensaje);

    int state = lora.transmit(mensaje);
    if (state == RADIOLIB_ERR_NONE) {
      Serial.println("[TX] Enviado OK");
    } else {
      Serial.print("[TX] Fallo al enviar, codigo: ");
      Serial.println(state);
    }

    delay(500); 
  }
}

