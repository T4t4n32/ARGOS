import { motion } from "framer-motion";
import { Eye } from "lucide-react";
import { scaleReveal, flipIn } from "@/lib/animations";

const NombreSection = () => (
  <section className="section-dark py-20">
    <div className="container max-w-3xl">
      <motion.div variants={scaleReveal} initial="hidden" whileInView="visible" viewport={{ once: true }} custom={0} className="text-center">
        <motion.div
          whileHover={{ scale: 1.2 }}
          transition={{ type: "spring", stiffness: 200 }}
        >
          <Eye className="mx-auto mb-4 h-12 w-12 text-primary drop-shadow-[0_0_20px_hsl(40_76%_50%/0.5)]" />
        </motion.div>
        <h2 className="mb-8 font-heading text-2xl font-bold uppercase tracking-wider md:text-3xl">Significado del Nombre</h2>
      </motion.div>
      <div className="grid gap-6 md:grid-cols-2">
        <motion.div variants={flipIn} initial="hidden" whileInView="visible" viewport={{ once: true }} custom={0} className="glass-card-hover p-8 group">
          <h3 className="mb-3 font-heading text-lg font-bold uppercase tracking-wider text-gradient-gold">ARGOS 👁️</h3>
          <p className="font-subtitle text-sm text-muted-foreground leading-relaxed">
            Hace referencia al gigante de cien ojos de la mitología griega que todo lo ve. Nuestro robot busca convertirse en los ojos de los arqueólogos en zonas peligrosas.
          </p>
        </motion.div>
        <motion.div variants={flipIn} initial="hidden" whileInView="visible" viewport={{ once: true }} custom={1} className="glass-card-hover p-8 group">
          <h3 className="mb-3 font-heading text-lg font-bold uppercase tracking-wider text-gradient-teal">KAIROS ⏳</h3>
          <p className="font-subtitle text-sm text-muted-foreground leading-relaxed">
            Kairos es una palabra del griego antiguo que significa "el momento oportuno". Juntos, ARGOS y Kairos representan la visión y el momento perfecto para innovar.
          </p>
        </motion.div>
      </div>
    </div>
  </section>
);

export default NombreSection;
