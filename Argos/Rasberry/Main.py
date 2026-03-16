import time
import RPi.GPIO as GPIO
from Control.motores import ControlMotores
from Comunicacion.lora import LoRaReceiver
from Sensores.mq5 import SensorMQ5


def main():
    print("Iniciando robot...")

    GPIO.setmode(GPIO.BCM)
    GPIO.setwarnings(False)

    motores = ControlMotores()
    lora = LoRaReceiver()
    sensor_gas = SensorMQ5(pin_gas=22)

    estado_movimiento = "stop"

    try:
        while True:

            comando = lora.read_command()

            if sensor_gas.gas_detectado():
                print("⚠️ GAS DETECTADO")

            if comando:
                print("📡 Recibido:", comando)
                
                comando = comando.strip().lower()
             
                if "adelante" in comando:
                    estado_movimiento = "adelante"
                elif "atras" in comando:
                    estado_movimiento = "atras"
                elif "stop" in comando:
                    estado_movimiento = "stop"


            if estado_movimiento == "adelante":
                motores.avanzar()

            elif estado_movimiento == "atras":
                motores.retroceder()

            elif estado_movimiento == "stop":
                motores.detener()

            time.sleep(0.05)

    except KeyboardInterrupt:
        print("\n🛑 Programa detenido")

    finally:
        print("Cerrando recursos...")
        motores.detener()
        GPIO.cleanup()

if __name__ == "__main__":
    main()