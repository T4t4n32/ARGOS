import RPi.GPIO as GPIO

class ControlMotores:
    def __init__(self, velocidad=30):
        GPIO.setmode(GPIO.BCM)
        GPIO.setwarnings(False)

        # Motor 1 (izquierdo delantero)
        self.en1 = 13
        self.in1_1 = 17
        self.in1_2 = 27

        # Configurar pines como salida
        self.pines = [self.en1, self.in1_1, self.in1_2]
        for pin in self.pines:
            GPIO.setup(pin, GPIO.OUT)

        # Configurar PWM en el pin en1
        self.pwm = GPIO.PWM(self.en1, 100)  # Frecuencia 100Hz
        self.pwm.start(0)  # Inicia apagado

        self.velocidad = velocidad  # Valor entre 0 y 100
        self.detener()

    # Métodos internos
    def _motor_adelante(self):
        GPIO.output(self.in1_1, GPIO.HIGH)
        GPIO.output(self.in1_2, GPIO.LOW)
        self.pwm.ChangeDutyCycle(self.velocidad)

    def _motor_atras(self):
        GPIO.output(self.in1_1, GPIO.LOW)
        GPIO.output(self.in1_2, GPIO.HIGH)
        self.pwm.ChangeDutyCycle(self.velocidad)

    def _motor_detener(self):
        GPIO.output(self.in1_1, GPIO.LOW)
        GPIO.output(self.in1_2, GPIO.LOW)
        self.pwm.ChangeDutyCycle(0)

    # Métodos públicos
    def avanzar(self):
        self._motor_adelante()

    def retroceder(self):
        self._motor_atras()

    def detener(self):
        self._motor_detener()

    def limpiar(self):
        self.pwm.stop()
        GPIO.cleanup()