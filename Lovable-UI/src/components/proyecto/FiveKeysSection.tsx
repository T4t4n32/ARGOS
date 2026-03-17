import { motion } from "framer-motion";
import { HelpCircle, Lightbulb, Cog, MapPin, TrendingUp } from "lucide-react";
import { staggerContainer, staggerItem, textReveal, scaleReveal } from "@/lib/animations";

const fiveKeys = [
  { icon: HelpCircle, label: "Qué", text: "Un robot terrestre explorador llamado ARGOS, equipado con sensores para analizar cuevas y cavidades naturales antes del ingreso humano." },
  { icon: Lightbulb, label: "Por qué", text: "Los arqueólogos enfrentan riesgos como derrumbes, gases tóxicos y zonas estructuralmente inestables al explorar cuevas con valor histórico." },
  { icon: Cog, label: "Cómo", text: "ARGOS integra sensores como el MQ-7 (monóxido de carbono), cámaras y plataformas como Arduino para monitorear condiciones en tiempo real." },
  { icon: MapPin, label: "Dónde", text: "En cuevas, cavernas y sitios arqueológicos subterráneos donde las condiciones pueden ser peligrosas para las personas." },
  { icon: TrendingUp, label: "Impacto", text: "Proteger vidas humanas, preservar patrimonio cultural y democratizar el acceso tecnológico en la exploración arqueológica." },
];

const FiveKeysSection = () => (
  <section className="section-darker py-20 border-t border-primary/10">
    <div className="container">
      <motion.h2
        className="mb-4 text-center font-heading text-2xl font-bold uppercase tracking-wider md:text-3xl"
        variants={textReveal}
        initial="hidden"
        whileInView="visible"
        viewport={{ once: true }}
        custom={0}
      >
        ARGOS en <span className="text-gradient-gold">5 Claves</span>
      </motion.h2>
      <motion.div className="mx-auto mb-12 h-1 w-16 rounded-full bg-primary" variants={scaleReveal} initial="hidden" whileInView="visible" viewport={{ once: true }} />
      <motion.div
        className="grid gap-5 sm:grid-cols-2 lg:grid-cols-5"
        variants={staggerContainer}
        initial="hidden"
        whileInView="visible"
        viewport={{ once: true }}
      >
        {fiveKeys.map((key) => (
          <motion.div key={key.label} variants={staggerItem}>
            <div className="glass-card-hover h-full p-6 text-center group">
              <motion.div
                className="mx-auto mb-4 flex h-14 w-14 items-center justify-center rounded-2xl bg-primary/15"
                whileHover={{ scale: 1.15, rotate: -5 }}
                transition={{ type: "spring", stiffness: 300 }}
              >
                <key.icon className="h-7 w-7 text-primary" />
              </motion.div>
              <h3 className="mb-2 font-heading text-xs font-bold uppercase tracking-[0.15em] text-primary">{key.label}</h3>
              <p className="font-subtitle text-xs leading-relaxed text-muted-foreground">{key.text}</p>
            </div>
          </motion.div>
        ))}
      </motion.div>
    </div>
  </section>
);

export default FiveKeysSection;
