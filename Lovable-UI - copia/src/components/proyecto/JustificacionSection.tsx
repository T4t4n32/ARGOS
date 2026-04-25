import { motion } from "framer-motion";
import { FileText } from "lucide-react";
import { slideFromLeft, slideFromRight, scaleReveal } from "@/lib/animations";

const JustificacionSection = () => (
  <section className="section-dark py-20">
    <div className="container max-w-4xl">
      <motion.div variants={scaleReveal} initial="hidden" whileInView="visible" viewport={{ once: true }} custom={0} className="text-center mb-10">
        <motion.div whileHover={{ rotate: 360 }} transition={{ duration: 0.6 }}>
          <FileText className="mx-auto mb-4 h-12 w-12 text-secondary drop-shadow-[0_0_20px_hsl(160_40%_45%/0.5)]" />
        </motion.div>
        <h2 className="font-heading text-2xl font-bold uppercase tracking-wider md:text-3xl">Justificación</h2>
        <motion.div className="mx-auto mt-4 h-1 w-16 rounded-full bg-secondary" variants={scaleReveal} initial="hidden" whileInView="visible" viewport={{ once: true }} />
      </motion.div>
      <motion.div variants={slideFromLeft} initial="hidden" whileInView="visible" viewport={{ once: true }} custom={0} className="glass-card p-8 mb-4">
        <p className="font-subtitle text-muted-foreground leading-relaxed">
          En la actualidad existen diferentes tipos de herramientas tecnológicas que aportan a la exploración de restos arqueológicos y detección de minerales, herramientas que suelen ser muy accesibles en la <strong className="text-primary">minería</strong> (por su retribución económica) pero poco accesibles en la <strong className="text-primary">arqueología</strong>.
        </p>
      </motion.div>
      <motion.div variants={slideFromRight} initial="hidden" whileInView="visible" viewport={{ once: true }} custom={0} className="glass-card p-8">
        <p className="font-subtitle text-muted-foreground leading-relaxed">
          ARGOS, desde la tecnología, no solo aporta a esta exploración, sino que también es de <strong className="text-primary">fácil acceso</strong> para diferentes arqueólogos, desde aficionados o principiantes hasta profesionales, democratizando el uso de herramientas tecnológicas en el campo arqueológico.
        </p>
      </motion.div>
    </div>
  </section>
);

export default JustificacionSection;
