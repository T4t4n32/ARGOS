import { motion } from "framer-motion";
import { Eye } from "lucide-react";
import { scaleReveal, textReveal } from "@/lib/animations";

const HeroSection = () => (
  <section className="relative py-24 overflow-hidden section-dark">
    <div className="absolute inset-0 flex items-center justify-center pointer-events-none">
      <motion.div
        className="h-[500px] w-[500px] rounded-full bg-primary/8 blur-[120px]"
        animate={{ scale: [1, 1.3, 1], opacity: [0.5, 0.9, 0.5] }}
        transition={{ duration: 5, repeat: Infinity, ease: "easeInOut" }}
      />
    </div>
    <div className="container relative z-10 text-center">
      <motion.p
        className="mb-3 font-subtitle text-sm font-semibold uppercase tracking-[0.3em] text-primary"
        initial={{ opacity: 0, letterSpacing: "0.5em" }}
        animate={{ opacity: 1, letterSpacing: "0.3em" }}
        transition={{ duration: 1, ease: [0.16, 1, 0.3, 1] }}
      >
        Proyecto Innovador · Temporada UNEARTHED
      </motion.p>
      <motion.div variants={scaleReveal} initial="hidden" animate="visible" custom={0}>
        <Eye className="mx-auto mb-4 h-14 w-14 text-primary drop-shadow-[0_0_30px_hsl(40_76%_50%/0.6)]" />
      </motion.div>
      <motion.h1
        className="font-heading text-5xl font-black md:text-7xl"
        variants={textReveal}
        initial="hidden"
        animate="visible"
        custom={1}
      >
        <span className="text-gradient-gold">ARGOS</span>
      </motion.h1>
      <motion.p
        className="mt-6 mx-auto max-w-2xl font-subtitle text-lg text-muted-foreground/80 md:text-xl"
        initial={{ opacity: 0, y: 20, filter: "blur(8px)" }}
        animate={{ opacity: 1, y: 0, filter: "blur(0px)" }}
        transition={{ delay: 0.6, duration: 0.8 }}
      >
        Robot explorador para seguridad en espeleología — <span className="text-primary">los ojos de los arqueólogos</span> en la oscuridad
      </motion.p>
    </div>
  </section>
);

export default HeroSection;
