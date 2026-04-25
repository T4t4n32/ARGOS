import lgpio

class ControlMotores:
    def __init__(self, velocidad=30):
        # Motor izquierdo
        self.en1   = 13
        self.in1_1 = 17
        self.in1_2 = 27
        # Motor derecho
        self.en2   = 12
        self.in2_1 = 22
        self.in2_2 = 23

        self.velocidad = velocidad

        # Abrir chip GPIO
        self.h = lgpio.gpiochip_open(0)

        # Configurar todos los pines como salida
        pines = [self.en1, self.in1_1, self.in1_2,
                 self.en2, self.in2_1, self.in2_2]
        for pin in pines:
            lgpio.gpio_claim_output(self.h, pin)

        # Iniciar PWM apagado
        lgpio.tx_pwm(self.h, self.en1, 100, 0)
        lgpio.tx_pwm(self.h, self.en2, 100, 0)

        self.detener()

    # ── Métodos internos ────────────────────────────────────

    def _izquierdo_adelante(self):
        lgpio.gpio_write(self.h, self.in1_1, 1)
        lgpio.gpio_write(self.h, self.in1_2, 0)
        lgpio.tx_pwm(self.h, self.en1, 100, self.velocidad)

    def _izquierdo_atras(self):
        lgpio.gpio_write(self.h, self.in1_1, 0)
        lgpio.gpio_write(self.h, self.in1_2, 1)
        lgpio.tx_pwm(self.h, self.en1, 100, self.velocidad)

    def _izquierdo_detener(self):
        lgpio.gpio_write(self.h, self.in1_1, 0)
        lgpio.gpio_write(self.h, self.in1_2, 0)
        lgpio.tx_pwm(self.h, self.en1, 100, 0)

    def _derecho_adelante(self):
        lgpio.gpio_write(self.h, self.in2_1, 1)
        lgpio.gpio_write(self.h, self.in2_2, 0)
        lgpio.tx_pwm(self.h, self.en2, 100, self.velocidad)

    def _derecho_atras(self):
        lgpio.gpio_write(self.h, self.in2_1, 0)
        lgpio.gpio_write(self.h, self.in2_2, 1)
        lgpio.tx_pwm(self.h, self.en2, 100, self.velocidad)

    def _derecho_detener(self):
        lgpio.gpio_write(self.h, self.in2_1, 0)
        lgpio.gpio_write(self.h, self.in2_2, 0)
        lgpio.tx_pwm(self.h, self.en2, 100, 0)

    # ── Métodos públicos ────────────────────────────────────

    def avanzar(self):
        """Ambos motores adelante"""
        self._izquierdo_adelante()
        self._derecho_adelante()

    def retroceder(self):
        """Ambos motores atrás"""
        self._izquierdo_atras()
        self._derecho_atras()

    def girar_derecha(self):
        """Motor izquierdo adelante, derecho atrás"""
        self._izquierdo_adelante()
        self._derecho_atras()

    def girar_izquierda(self):
        """Motor derecho adelante, izquierdo atrás"""
        self._derecho_adelante()
        self._izquierdo_atras()

    def detener(self):
        """Detiene ambos motores"""
        self._izquierdo_detener()
        self._derecho_detener()

    def limpiar(self):
        lgpio.tx_pwm(self.h, self.en1, 100, 0)
        lgpio.tx_pwm(self.h, self.en2, 100, 0)
        lgpio.gpiochip_close(self.h)
