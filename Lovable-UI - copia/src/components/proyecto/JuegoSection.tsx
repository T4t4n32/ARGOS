import { motion } from "framer-motion";
import { Gamepad2, ArrowRight } from "lucide-react";
import { Link } from "react-router-dom";
import { scaleReveal } from "@/lib/animations";

const JuegoSection = () => (
  <section className="section-darker py-20">
    <div className="container">
      <motion.div
        variants={scaleReveal}
        initial="hidden"
        whileInView="visible"
        viewport={{ once: true }}
        custom={0}
        className="mx-auto max-w-3xl glass-card p-10 relative overflow-hidden group"
      >
        {/* Animated gradient border top */}
        <motion.div
          className="absolute top-0 left-0 right-0 h-1 bg-gradient-to-r from-accent via-primary to-secondary"
          initial={{ scaleX: 0 }}
          whileInView={{ scaleX: 1 }}
          viewport={{ once: true }}
          transition={{ delay: 0.5, duration: 1, ease: [0.16, 1, 0.3, 1] }}
          style={{ transformOrigin: "left" }}
        />
        <div className="flex items-center gap-4 mb-5">
          <motion.div whileHover={{ rotate: 15, scale: 1.2 }} transition={{ type: "spring" }}>
            <Gamepad2 className="h-8 w-8 text-accent drop-shadow-[0_0_12px_hsl(8_70%_52%/0.5)]" />
          </motion.div>
          <h2 className="font-heading text-xl font-bold uppercase tracking-wider">Juego Educativo</h2>
        </div>
        <p className="mb-3 font-subtitle text-muted-foreground leading-relaxed">
          Como parte de nuestro proyecto, también creamos un <strong className="text-primary">juego educativo</strong> diseñado para sensibilizar a una población más joven sobre la importancia de la arqueología y la preservación del patrimonio cultural.
        </p>
        <p className="mb-6 font-subtitle text-muted-foreground leading-relaxed">
          Este juego busca que los niños aprendan de forma interactiva y divertida sobre los desafíos que enfrentan los arqueólogos.
        </p>
        <Link to="/juego-del-robot" className="inline-flex items-center gap-2 rounded-lg bg-accent px-6 py-3 font-subtitle text-sm font-bold text-accent-foreground uppercase tracking-wider transition-all duration-300 hover:glow-crimson hover:scale-105 group/btn">
          Conoce el Juego del Robot
          <ArrowRight className="h-4 w-4 transition-transform group-hover/btn:translate-x-1" />
        </Link>
      </motion.div>
    </div>
  </section>
);

export default JuegoSection;
