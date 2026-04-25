import { motion } from "framer-motion";
import { Clock } from "lucide-react";
import { textReveal, scaleReveal } from "@/lib/animations";

const weeklyTimeline = [
  { week: "Semana 1", task: "Organización del equipo de trabajo. Se da a conocer el enfoque de temporada, escuchando ideas de cada miembro." },
  { week: "Semana 2", task: "Contextualización y asignación de funciones de consulta. Recopilación de información desde Google Académico." },
  { week: "Semana 3", task: "Socialización sobre los diferentes problemas en excavaciones hoy día, enfocados hacia la arqueología y cuevas." },
  { week: "Semana 4", task: "Análisis del enfoque del proyecto. Se plantea una solución desde lo innovador, tecnológico y la seguridad." },
  { week: "Semana 5", task: "Retroalimentación por parte del arqueólogo. Se validan 4 problemáticas fundamentales en el proceso." },
  { week: "Semana 6", task: "Llega la pista. Se procede al armado y cada una de las misiones. El grupo se separa en dos frentes." },
  { week: "Semana 7", task: "Pista terminada. Elaboración de attachments y primeros lanzamientos. Inicio de prototipado." },
  { week: "Semana 8", task: "Después de dos lanzamientos hay que modificar el attachment. Información adicional sobre otras tecnologías." },
  { week: "Semana 9", task: "Mejora del attachment en el juego del robot. Determinación de tecnologías a emplear desde el proyecto." },
  { week: "Semana 10", task: "Primeros resultados en el juego del robot. Investigación de sensores. Bot de desplazamiento terrestre." },
  { week: "Semana 11", task: "Pendiente" },
  { week: "Semana 12", task: "Pendiente" },
  { week: "Semana 13", task: "Pendiente" },
  { week: "Semana 14", task: "Preparación de la presentación, cartelera y exposición para la competencia." },
];

const TimelineSection = () => (
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
        <motion.div whileHover={{ rotate: 360 }} transition={{ duration: 0.5 }} className="inline-block mr-3">
          <Clock className="inline h-8 w-8 text-secondary drop-shadow-[0_0_12px_hsl(160_40%_45%/0.5)]" />
        </motion.div>
        Avances del <span className="text-gradient-teal">Proyecto</span>
      </motion.h2>
      <motion.p className="mb-4 text-center font-subtitle text-sm text-muted-foreground/70" initial={{ opacity: 0 }} whileInView={{ opacity: 1 }} viewport={{ once: true }} transition={{ delay: 0.3 }}>
        Línea de tiempo de nuestro desarrollo
      </motion.p>
      <motion.div className="mx-auto mb-12 h-1 w-16 rounded-full bg-secondary" variants={scaleReveal} initial="hidden" whileInView="visible" viewport={{ once: true }} />
      
      <div className="relative mx-auto max-w-2xl">
        {/* Animated timeline line */}
        <motion.div
          className="absolute left-4 top-0 w-0.5 bg-gradient-to-b from-primary/50 via-secondary/50 to-primary/50 md:left-1/2 md:-translate-x-1/2"
          initial={{ height: 0 }}
          whileInView={{ height: "100%" }}
          viewport={{ once: true }}
          transition={{ duration: 2, ease: [0.16, 1, 0.3, 1] }}
        />
        {weeklyTimeline.map((item, i) => (
          <motion.div
            key={item.week}
            className="relative mb-8 pl-12 md:pl-0"
            initial={{ opacity: 0, x: i % 2 === 0 ? -40 : 40, filter: "blur(4px)" }}
            whileInView={{ opacity: 1, x: 0, filter: "blur(0px)" }}
            viewport={{ once: true }}
            transition={{ delay: i * 0.06, duration: 0.6, ease: [0.16, 1, 0.3, 1] }}
          >
            <motion.div
              className={`absolute left-2 top-1 h-5 w-5 rounded-full border-4 ${item.task === "Pendiente" ? "border-muted-foreground/40" : "border-primary"} bg-background md:left-1/2 md:-translate-x-1/2`}
              initial={{ scale: 0 }}
              whileInView={{ scale: 1 }}
              viewport={{ once: true }}
              transition={{ delay: i * 0.06 + 0.2, type: "spring", stiffness: 300 }}
              style={item.task !== "Pendiente" ? { boxShadow: "0 0 12px hsl(40 76% 50% / 0.4)" } : {}}
            />
            <div className={`md:w-5/12 ${i % 2 === 0 ? "md:mr-auto md:pr-8 md:text-right" : "md:ml-auto md:pl-8"}`}>
              <h3 className="font-heading text-xs font-bold uppercase tracking-wider text-primary">{item.week}</h3>
              <p className={`font-subtitle text-sm ${item.task === "Pendiente" ? "text-muted-foreground/50 italic" : "text-muted-foreground"}`}>{item.task}</p>
            </div>
          </motion.div>
        ))}
      </div>
    </div>
  </section>
);

export default TimelineSection;
