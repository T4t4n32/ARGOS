import { motion } from "framer-motion";
import { AlertTriangle, Pickaxe } from "lucide-react";
import { textReveal, flipIn, slideFromLeft, scaleReveal } from "@/lib/animations";

const problems = [
  { area: "Cultural", desc: "Aquí surge un desafío ético fundamental: desde la intervención de sitios arqueológicos que las comunidades locales consideran sagrados, donde el manejo de restos humanos y objetos ancestrales no es solo un proceso técnico, sino una acción que impacta directamente en la identidad y las creencias de poblaciones.", color: "text-primary" },
  { area: "Económica", desc: "Este es otro de los grandes desafíos, ya que desde el ámbito de la minería sí se efectúa buena inversión debido a la retribución, sin embargo la arqueología no cuenta con mucha inversión debido a la retribución económica que puede generar.", color: "text-primary" },
  { area: "Seguridad", desc: "Dentro de las excavaciones podemos encontrar materiales poco rígidos con precipitaciones, lugares de difícil acceso y también con condiciones de aire contaminado por diferentes tipos de gases, ocasionando problemas respiratorios.", color: "text-accent" },
  { area: "Tecnológica", desc: "Aunque existen herramientas como el LIDAR o el Georradar (GPR), estas tecnologías enfrentan dificultades en terrenos con alta densidad de vegetación, humedad extrema o suelos con alta mineralización.", color: "text-secondary" },
];

const miningProblems = [
  "Desertización: deforestación, erosión, pérdida de suelo fértil",
  "Modificación del relieve, impacto visual, alteración de la dinámica de los procesos de ladera",
  "Aumento de la escorrentía y erosión",
  "Alteraciones en el nivel freático",
];

const ProblematicasSection = () => (
  <section className="section-dark py-20">
    <div className="container">
      <motion.h2
        className="mb-3 text-center font-heading text-2xl font-bold uppercase tracking-wider md:text-3xl"
        variants={textReveal}
        initial="hidden"
        whileInView="visible"
        viewport={{ once: true }}
        custom={0}
      >
        Problemáticas en <span className="text-gradient-crimson">Arqueología</span>
      </motion.h2>
      <motion.p
        className="mb-4 text-center font-subtitle text-sm text-muted-foreground/70"
        initial={{ opacity: 0 }}
        whileInView={{ opacity: 1 }}
        viewport={{ once: true }}
        transition={{ delay: 0.3 }}
      >
        Desafíos que enfrentan los arqueólogos en la exploración subterránea
      </motion.p>
      <motion.div className="mx-auto mb-12 h-1 w-16 rounded-full bg-accent" variants={scaleReveal} initial="hidden" whileInView="visible" viewport={{ once: true }} />
      
      <div className="mx-auto grid max-w-4xl gap-6 md:grid-cols-2">
        {problems.map((p, i) => (
          <motion.div key={p.area} variants={flipIn} initial="hidden" whileInView="visible" viewport={{ once: true }} custom={i} className="glass-card-hover p-6 group">
            <div className="flex items-center gap-2 mb-3">
              <motion.div whileHover={{ rotate: 15, scale: 1.2 }} transition={{ type: "spring" }}>
                <AlertTriangle className={`h-5 w-5 ${p.color}`} />
              </motion.div>
              <h3 className="font-heading text-xs font-bold uppercase tracking-wider">Desde lo {p.area}</h3>
            </div>
            <p className="font-subtitle text-sm text-muted-foreground leading-relaxed">{p.desc}</p>
          </motion.div>
        ))}
      </div>

      <motion.div variants={slideFromLeft} initial="hidden" whileInView="visible" viewport={{ once: true }} custom={0} className="mx-auto mt-12 max-w-3xl glass-card p-8">
        <div className="flex items-center gap-3 mb-4">
          <Pickaxe className="h-6 w-6 text-accent" />
          <h3 className="font-heading text-xs font-bold uppercase tracking-wider">¿Qué problemas puede causar la minería?</h3>
        </div>
        <ul className="space-y-2">
          {miningProblems.map((p, i) => (
            <motion.li
              key={p}
              className="flex items-start gap-3 font-subtitle text-sm text-muted-foreground"
              initial={{ opacity: 0, x: -15 }}
              whileInView={{ opacity: 1, x: 0 }}
              viewport={{ once: true }}
              transition={{ delay: 0.4 + i * 0.1 }}
            >
              <span className="mt-1.5 h-1.5 w-1.5 shrink-0 rounded-full bg-accent" />
              {p}
            </motion.li>
          ))}
        </ul>
      </motion.div>
    </div>
  </section>
);

export default ProblematicasSection;
