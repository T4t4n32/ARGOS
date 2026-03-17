import { motion } from "framer-motion";
import { Bone, Users } from "lucide-react";
import { slideFromLeft, slideFromRight } from "@/lib/animations";

const PaleontologiaImpactoSection = () => (
  <section className="section-darker py-20">
    <div className="container">
      <div className="mx-auto max-w-4xl grid gap-8 md:grid-cols-2">
        <motion.div variants={slideFromLeft} initial="hidden" whileInView="visible" viewport={{ once: true }} custom={0} className="glass-card-hover p-8 group">
          <div className="flex items-center gap-3 mb-4">
            <motion.div whileHover={{ rotate: -10, scale: 1.1 }} transition={{ type: "spring" }}>
              <Bone className="h-7 w-7 text-secondary drop-shadow-[0_0_12px_hsl(160_40%_45%/0.5)]" />
            </motion.div>
            <h3 className="font-heading text-sm font-bold uppercase tracking-wider">Paleontología</h3>
          </div>
          <p className="font-subtitle text-sm text-muted-foreground leading-relaxed">
            Los fósiles son valiosos archivos del pasado. Conservan detalles sobre los seres vivos de hace miles o cientos de millones de años. Su estudio nos ayuda a comprender la evolución de las especies a lo largo del tiempo.
          </p>
          <p className="mt-3 font-subtitle text-sm text-muted-foreground leading-relaxed">
            También pueden revelar las dietas o los patrones migratorios de especies desaparecidas hace mucho tiempo, incluidos nuestros antepasados.
          </p>
        </motion.div>
        <motion.div variants={slideFromRight} initial="hidden" whileInView="visible" viewport={{ once: true }} custom={0} className="glass-card-hover p-8 group">
          <div className="flex items-center gap-3 mb-4">
            <motion.div whileHover={{ rotate: 10, scale: 1.1 }} transition={{ type: "spring" }}>
              <Users className="h-7 w-7 text-accent drop-shadow-[0_0_12px_hsl(8_70%_52%/0.5)]" />
            </motion.div>
            <h3 className="font-heading text-sm font-bold uppercase tracking-wider">Impacto Social</h3>
          </div>
          <p className="font-subtitle text-sm text-muted-foreground leading-relaxed">
            La arqueología tiene un impacto importante en la sociedad porque nos ayuda a conocer cómo vivían las personas en el pasado y a entender mejor nuestra historia.
          </p>
          <p className="mt-3 font-subtitle text-sm text-muted-foreground leading-relaxed">
            Muchos sitios arqueológicos atraen turistas, lo que puede generar trabajo y beneficios para las comunidades locales.
          </p>
        </motion.div>
      </div>
    </div>
  </section>
);

export default PaleontologiaImpactoSection;
