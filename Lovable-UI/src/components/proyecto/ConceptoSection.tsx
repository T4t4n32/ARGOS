import { motion } from "framer-motion";
import PhotoPlaceholder from "@/components/PhotoPlaceholder";
import { slideFromLeft, slideFromRight } from "@/lib/animations";

const ConceptoSection = () => (
  <section className="section-darker py-20">
    <div className="container">
      <div className="grid items-center gap-12 md:grid-cols-2">
        <motion.div variants={slideFromLeft} initial="hidden" whileInView="visible" viewport={{ once: true }} custom={0}>
          <h2 className="mb-6 font-heading text-2xl font-bold uppercase tracking-wider md:text-3xl">Concepto Central: <span className="text-gradient-teal">Espeleología</span></h2>
          <div className="space-y-4">
            <p className="font-subtitle text-muted-foreground leading-relaxed">
              La <strong className="text-foreground">espeleología</strong> (del griego σπηλαιου <em>spelaiou</em> que significa «cueva» y <em>-logía</em>, tratado) es la práctica de explorar y/o estudiar las cavidades naturales del subsuelo.
            </p>
            <p className="font-subtitle text-muted-foreground leading-relaxed">
              A partir de sus raíces griegas, se considera a la espeleología como el estudio científico que, apoyado en la geología, analiza el desarrollo, evolución y formaciones geológicas de las cavidades naturales (espeleotemas o espeleolitos).
            </p>
            <p className="font-subtitle text-muted-foreground leading-relaxed">
              Desde el punto de vista geológico, forma parte de la <strong className="text-foreground">geomorfología</strong> y sirve de apoyo a la <strong className="text-foreground">hidrogeología</strong>.
            </p>
          </div>
          <motion.div
            className="glass-card p-4 mt-6"
            initial={{ opacity: 0, x: -30 }}
            whileInView={{ opacity: 1, x: 0 }}
            viewport={{ once: true }}
            transition={{ delay: 0.4, duration: 0.6 }}
          >
            <h4 className="mb-1 font-heading text-xs font-bold uppercase tracking-wider text-accent">⛏️ Excavaciones en cueva</h4>
            <p className="font-subtitle text-sm text-muted-foreground">Derrumbes de zanjas, derrumbes, caídas, caída de cargas, atmósferas peligrosas y contacto con líneas eléctricas aéreas son los principales riesgos.</p>
          </motion.div>
        </motion.div>
        <motion.div variants={slideFromRight} initial="hidden" whileInView="visible" viewport={{ once: true }} custom={0}>
          <PhotoPlaceholder aspectRatio="video" label="📷 Robot ARGOS aquí" />
        </motion.div>
      </div>
    </div>
  </section>
);

export default ConceptoSection;
