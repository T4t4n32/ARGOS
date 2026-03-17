import { motion } from "framer-motion";
import { Cpu } from "lucide-react";
import VideoPlaceholder from "@/components/VideoPlaceholder";
import { textReveal, slideFromLeft, slideFromRight, scaleReveal } from "@/lib/animations";

const TecnologiaSection = () => (
  <section className="section-dark py-20">
    <div className="container">
      <motion.h2
        className="mb-4 text-center font-heading text-2xl font-bold uppercase tracking-wider md:text-3xl"
        variants={textReveal}
        initial="hidden"
        whileInView="visible"
        viewport={{ once: true }}
        custom={0}
      >
        <span className="text-gradient-teal">Tecnología</span>
      </motion.h2>
      <motion.div className="mx-auto mb-12 h-1 w-16 rounded-full bg-secondary" variants={scaleReveal} initial="hidden" whileInView="visible" viewport={{ once: true }} />
      <div className="mx-auto max-w-3xl space-y-6">
        <motion.div variants={slideFromLeft} initial="hidden" whileInView="visible" viewport={{ once: true }} custom={0} className="glass-card p-8">
          <div className="flex items-center gap-3 mb-4">
            <motion.div whileHover={{ rotate: 180 }} transition={{ duration: 0.4 }}>
              <Cpu className="h-7 w-7 text-secondary drop-shadow-[0_0_12px_hsl(160_40%_45%/0.5)]" />
            </motion.div>
            <h3 className="font-heading text-sm font-bold uppercase tracking-wider">Sensores y Plataformas</h3>
          </div>
          <div className="space-y-3">
            <p className="font-subtitle text-muted-foreground leading-relaxed">El robot integra sensores para analizar el entorno de las cuevas y garantizar la seguridad antes del ingreso humano.</p>
            <p className="font-subtitle text-muted-foreground leading-relaxed">
              Uno de los sensores evaluados es el <strong className="text-primary">sensor MQ-7</strong> para detección de monóxido de carbono.
            </p>
            <p className="font-subtitle text-muted-foreground leading-relaxed">
              Compatible con <strong className="text-primary">Arduino</strong> y <strong className="text-primary">Raspberry Pi</strong> para monitoreo en tiempo real.
            </p>
          </div>
        </motion.div>

        <motion.div variants={slideFromRight} initial="hidden" whileInView="visible" viewport={{ once: true }} custom={0} className="glass-card p-8">
          <h3 className="mb-4 font-heading text-sm font-bold uppercase tracking-wider">🔬 ¿Por qué el sensor MQ-7?</h3>
          <div className="space-y-3">
            <p className="font-subtitle text-sm text-muted-foreground leading-relaxed">
              Para comprobar la calidad del oxígeno se usan analizadores de pureza para gas o sensores de oxígeno disuelto, usando tecnologías como láseres (TDL) o fluorescencia.
            </p>
            <p className="font-subtitle text-sm text-muted-foreground leading-relaxed">
              Se optó por un <strong className="text-primary">sensor electroquímico</strong>: el <strong className="text-primary">Paradisetronic.com MQ-7</strong>, un módulo de sensor de CO a 5V con salida analógica y digital.
            </p>
          </div>
        </motion.div>
      </div>

      <motion.div
        className="mt-12"
        initial={{ opacity: 0, scale: 0.9, filter: "blur(10px)" }}
        whileInView={{ opacity: 1, scale: 1, filter: "blur(0px)" }}
        viewport={{ once: true }}
        transition={{ duration: 0.8 }}
      >
        <VideoPlaceholder label="🎥 Video del proyecto ARGOS aquí" />
      </motion.div>
    </div>
  </section>
);

export default TecnologiaSection;
