class SensorMQ5:
    def __init__(self, pin_gas=22):
        self.pin_gas = pin_gas
        import RPi.GPIO as GPIO
        GPIO.setup(self.pin_gas, GPIO.IN)
        import time
        time.sleep(2)

    def gas_detectado(self):
        import RPi.GPIO as GPIO
        return GPIO.input(self.pin_gas) == 0

    def leer_estado(self):
        return "GAS_DETECTADO" if self.gas_detectado() else "AIRE_LIMPIO"

    def limpiar(self):
        pass  # No hace nada, limpieza general en Main.py