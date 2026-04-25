import { motion } from "framer-motion";
import { Landmark } from "lucide-react";
import { scaleReveal, staggerContainer, staggerItem, textReveal } from "@/lib/animations";

const cases = [
  { title: "Tumba de Tutankamón", location: "Egipto 🇪🇬", desc: "El cambio climático ha hecho que cambien las condiciones de este sitio arqueológico. Un aumento en la humedad ha creado un ambiente propicio para el crecimiento de hongos que podrían dañar las pinturas y ornamentos de la tumba." },
  { title: "Pompeya", location: "Italia 🇮🇹", desc: "La arqueología en Pompeya enfrenta una crisis continua de preservación, marcada por el rápido deterioro de sus estructuras expuestas a la intemperie, la humedad y el turismo masivo." },
  { title: "Machu Picchu", location: "Perú 🇵🇪", desc: "El cambio climático y la gestión de turismo masivo son los retos mayores a los que tendrá que enfrentarse la ciudadela inca en los próximos años." },
];

const CasosRealesSection = () => (
  <section className="section-dark py-20">
    <div className="container">
      <motion.div variants={scaleReveal} initial="hidden" whileInView="visible" viewport={{ once: true }} custom={0} className="text-center mb-4">
        <motion.div whileHover={{ scale: 1.2 }} transition={{ type: "spring" }}>
          <Landmark className="mx-auto mb-4 h-12 w-12 text-primary drop-shadow-[0_0_20px_hsl(40_76%_50%/0.5)]" />
        </motion.div>
        <motion.h2 className="font-heading text-2xl font-bold uppercase tracking-wider md:text-3xl" variants={textReveal} initial="hidden" whileInView="visible" viewport={{ once: true }} custom={0}>
          Problemática en el <span className="text-gradient-gold">Mundo</span>
        </motion.h2>
        <motion.p className="mt-3 font-subtitle text-sm text-muted-foreground/70" initial={{ opacity: 0 }} whileInView={{ opacity: 1 }} viewport={{ once: true }} transition={{ delay: 0.3 }}>
          Casos reales que evidencian la necesidad de innovar
        </motion.p>
      </motion.div>
      <motion.div className="mx-auto mb-12 h-1 w-16 rounded-full bg-primary" variants={scaleReveal} initial="hidden" whileInView="visible" viewport={{ once: true }} />
      <motion.div
        className="mx-auto grid max-w-5xl gap-6 md:grid-cols-3"
        variants={staggerContainer}
        initial="hidden"
        whileInView="visible"
        viewport={{ once: true }}
      >
        {cases.map((c) => (
          <motion.div key={c.title} variants={staggerItem}>
            <div className="glass-card-hover h-full p-8 group relative overflow-hidden">
              <div className="absolute top-0 left-0 right-0 h-1 bg-gradient-to-r from-primary/0 via-primary/50 to-primary/0 opacity-0 group-hover:opacity-100 transition-opacity duration-500" />
              <p className="mb-1 font-heading text-[10px] font-bold uppercase tracking-[0.25em] text-secondary">{c.location}</p>
              <h3 className="mb-3 font-heading text-sm font-bold uppercase tracking-wider">{c.title}</h3>
              <p className="font-subtitle text-sm text-muted-foreground leading-relaxed">{c.desc}</p>
            </div>
          </motion.div>
        ))}
      </motion.div>
    </div>
  </section>
);

export default CasosRealesSection;
