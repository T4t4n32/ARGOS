import { motion } from "framer-motion";
import { Link } from "react-router-dom";
import Navbar from "@/components/Navbar";
import BackButton from "@/components/BackButton";
import Footer from "@/components/Footer";
import SectionDivider from "@/components/SectionDivider";
import PhotoPlaceholder from "@/components/PhotoPlaceholder";
import { Users, Lightbulb, Heart, Search, Zap, PartyPopper, ArrowRight } from "lucide-react";
import { fadeUp, textReveal, slideFromLeft, slideFromRight, scaleReveal, staggerContainer, staggerItem, flipIn } from "@/lib/animations";

const students = [
  { name: "Jose Luis Jiménez", role: "Integrante" },
  { name: "Sebastián Sánchez", role: "Integrante" },
  { name: "Samuel Monzalve", role: "Integrante" },
  { name: "Juan E. Gutiérrez", role: "Integrante" },
  { name: "Raúl A. Castillo", role: "Integrante" },
  { name: "Luisa F. Ávila", role: "Integrante" },
  { name: "Maria A. Zúñiga", role: "Integrante" },
  { name: "Sofia Vasco Riaño", role: "Integrante" },
  { name: "Bramdon Vizcaíno", role: "Integrante" },
  { name: "Ericka A. V. Viafara", role: "Integrante" },
];

const coaches = [
  { name: "Richard Suarez", role: "Profesor / Coach" },
  { name: "Diego Peña", role: "Profesor / Coach" },
];

const valoresFIRST = [
  { icon: Search, label: "Descubrimiento", slug: "descubrimiento", color: "primary", desc: "Exploramos nuevas habilidades, ideas y conceptos." },
  { icon: Lightbulb, label: "Innovación", slug: "innovacion", color: "accent", desc: "Usamos creatividad y perseverancia para resolver problemas." },
  { icon: Zap, label: "Impacto", slug: "impacto", color: "secondary", desc: "Aplicamos lo aprendido para mejorar nuestro mundo." },
  { icon: Heart, label: "Inclusión", slug: "inclusion", color: "primary", desc: "Nos respetamos y valoramos nuestras diferencias." },
  { icon: Users, label: "Trabajo en Equipo", slug: "trabajo-en-equipo", color: "secondary", desc: "Somos más fuertes cuando trabajamos juntos." },
  { icon: PartyPopper, label: "Diversión", slug: "diversion", color: "accent", desc: "¡Disfrutamos y celebramos lo que hacemos!" },
];

const timeline = [
  { phase: "Entrenamientos", desc: "Formación en programación, construcción y valores FIRST." },
  { phase: "Preparación", desc: "Desarrollo del proyecto innovador ARGOS y diseño del robot." },
  { phase: "Competencias", desc: "Participación en torneos regionales y nacionales FLL." },
];

const QuienesSomos = () => {
  return (
    <div className="flex min-h-screen flex-col bg-background">
      <Navbar />
      <BackButton />

      {/* Hero */}
      <section className="relative py-24 overflow-hidden section-dark">
        <div className="absolute inset-0 flex items-center justify-center pointer-events-none">
          <motion.div
            className="h-[400px] w-[400px] rounded-full bg-primary/8 blur-[100px]"
            animate={{ scale: [1, 1.2, 1] }}
            transition={{ duration: 5, repeat: Infinity, ease: "easeInOut" }}
          />
        </div>
        <div className="container relative z-10 text-center">
          <motion.h1
            className="font-heading text-3xl font-black uppercase tracking-wider md:text-5xl lg:text-6xl"
            variants={textReveal}
            initial="hidden"
            animate="visible"
            custom={0}
          >
            Quiénes <span className="text-gradient-gold">Somos</span>
          </motion.h1>
          <motion.p
            className="mt-5 font-subtitle text-lg text-muted-foreground/80"
            initial={{ opacity: 0, y: 15, filter: "blur(6px)" }}
            animate={{ opacity: 1, y: 0, filter: "blur(0px)" }}
            transition={{ delay: 0.4, duration: 0.8 }}
          >
            Conoce al equipo detrás de CaliBots Kairos
          </motion.p>
        </div>
      </section>

      <SectionDivider variant="gold" />

      {/* Historia */}
      <section className="section-darker py-20">
        <div className="container">
          <div className="grid items-center gap-12 md:grid-cols-2">
            <motion.div variants={slideFromLeft} initial="hidden" whileInView="visible" viewport={{ once: true }} custom={0}>
              <h2 className="mb-6 font-heading text-2xl font-bold uppercase tracking-wider md:text-3xl">Nuestra <span className="text-gradient-teal">Esencia</span></h2>
              <div className="space-y-4">
                <p className="font-subtitle text-muted-foreground leading-relaxed">
                  Somos CaliBots Kairos, un equipo de FIRST LEGO League Challenge de Cali, Colombia, estudiantes con orgullo de Comfandi.
                </p>
                <p className="font-subtitle text-muted-foreground leading-relaxed">
                  Nuestro nombre define nuestra esencia: creemos en el <strong className="text-primary">Kairos</strong>, el momento exacto para aprender, crear e innovar frente a los desafíos tecnológicos de hoy.
                </p>
                <p className="font-subtitle text-muted-foreground leading-relaxed">
                  En la temporada <strong className="text-primary">Unearthed</strong> nos sumergimos en el presente para redescubrir los tesoros del pasado.
                </p>
                <p className="font-subtitle text-muted-foreground leading-relaxed">
                  En CaliBots Kairos cada reto es la oportunidad perfecta para dejar huella y demostrar que desde nuestra región también se construye el futuro.
                </p>
              </div>
            </motion.div>
            <motion.div variants={slideFromRight} initial="hidden" whileInView="visible" viewport={{ once: true }} custom={0}>
              <PhotoPlaceholder aspectRatio="video" label="📷 Foto del equipo aquí" />
            </motion.div>
          </div>
        </div>
      </section>

      <SectionDivider variant="teal" />

      {/* Estudiantes */}
      <section className="section-dark py-20">
        <div className="container">
          <motion.h2
            className="mb-4 text-center font-heading text-2xl font-bold uppercase tracking-wider md:text-3xl"
            variants={textReveal}
            initial="hidden"
            whileInView="visible"
            viewport={{ once: true }}
            custom={0}
          >
            Nuestro <span className="text-gradient-gold">Equipo</span>
          </motion.h2>
          <motion.div className="mx-auto mb-12 h-1 w-16 rounded-full bg-primary" variants={scaleReveal} initial="hidden" whileInView="visible" viewport={{ once: true }} />
          <motion.div
            className="grid gap-6 sm:grid-cols-2 lg:grid-cols-5"
            variants={staggerContainer}
            initial="hidden"
            whileInView="visible"
            viewport={{ once: true }}
          >
            {students.map((member) => (
              <motion.div key={member.name} variants={staggerItem}>
                <div className="glass-card-hover overflow-hidden group">
                  <div className="relative overflow-hidden">
                    <PhotoPlaceholder aspectRatio="portrait" className="rounded-none" />
                    <div className="absolute inset-0 bg-gradient-to-t from-background/80 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-500" />
                  </div>
                  <div className="p-4 text-center">
                    <h3 className="font-heading text-xs font-bold uppercase tracking-wider">{member.name}</h3>
                    <span className="mt-1 inline-block rounded-full border border-secondary/30 bg-secondary/10 px-3 py-0.5 font-subtitle text-xs font-semibold text-secondary">{member.role}</span>
                  </div>
                </div>
              </motion.div>
            ))}
          </motion.div>
        </div>
      </section>

      <SectionDivider variant="crimson" />

      {/* Coaches */}
      <section className="section-darker py-20">
        <div className="container">
          <motion.h2
            className="mb-4 text-center font-heading text-2xl font-bold uppercase tracking-wider md:text-3xl"
            variants={textReveal}
            initial="hidden"
            whileInView="visible"
            viewport={{ once: true }}
            custom={0}
          >
            Nuestros <span className="text-gradient-crimson">Coaches</span>
          </motion.h2>
          <motion.div className="mx-auto mb-12 h-1 w-16 rounded-full bg-accent" variants={scaleReveal} initial="hidden" whileInView="visible" viewport={{ once: true }} />
          <div className="mx-auto grid max-w-lg gap-6 sm:grid-cols-2">
            {coaches.map((coach, i) => (
              <motion.div key={coach.name} variants={i === 0 ? slideFromLeft : slideFromRight} initial="hidden" whileInView="visible" viewport={{ once: true }} custom={0}>
                <div className="glass-card-hover overflow-hidden group">
                  <PhotoPlaceholder aspectRatio="portrait" className="rounded-none" />
                  <div className="p-4 text-center">
                    <h3 className="font-heading text-xs font-bold uppercase tracking-wider">{coach.name}</h3>
                    <span className="mt-1 inline-block rounded-full border border-accent/30 bg-accent/10 px-3 py-0.5 font-subtitle text-xs font-semibold text-accent">{coach.role}</span>
                  </div>
                </div>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      <SectionDivider variant="teal" />

      {/* Recorrido */}
      <section className="section-dark py-20">
        <div className="container">
          <motion.h2
            className="mb-4 text-center font-heading text-2xl font-bold uppercase tracking-wider md:text-3xl"
            variants={textReveal}
            initial="hidden"
            whileInView="visible"
            viewport={{ once: true }}
            custom={0}
          >
            Nuestro <span className="text-gradient-teal">Recorrido</span>
          </motion.h2>
          <motion.div className="mx-auto mb-12 h-1 w-16 rounded-full bg-secondary" variants={scaleReveal} initial="hidden" whileInView="visible" viewport={{ once: true }} />
          <div className="relative mx-auto max-w-2xl">
            <motion.div
              className="absolute left-4 top-0 w-0.5 bg-gradient-to-b from-secondary/50 via-primary/50 to-secondary/50 md:left-1/2 md:-translate-x-1/2"
              initial={{ height: 0 }}
              whileInView={{ height: "100%" }}
              viewport={{ once: true }}
              transition={{ duration: 1.5, ease: [0.16, 1, 0.3, 1] }}
            />
            {timeline.map((item, i) => (
              <motion.div
                key={item.phase}
                className="relative mb-10 pl-12 md:pl-0"
                initial={{ opacity: 0, x: i % 2 === 0 ? -40 : 40 }}
                whileInView={{ opacity: 1, x: 0 }}
                viewport={{ once: true }}
                transition={{ delay: i * 0.2, duration: 0.7, ease: [0.16, 1, 0.3, 1] }}
              >
                <motion.div
                  className="absolute left-2 top-1 h-5 w-5 rounded-full border-4 border-secondary bg-background shadow-[0_0_12px_hsl(160_40%_45%/0.4)] md:left-1/2 md:-translate-x-1/2"
                  initial={{ scale: 0 }}
                  whileInView={{ scale: 1 }}
                  viewport={{ once: true }}
                  transition={{ delay: i * 0.2 + 0.3, type: "spring", stiffness: 300 }}
                />
                <div className={`md:w-5/12 ${i % 2 === 0 ? "md:mr-auto md:pr-8 md:text-right" : "md:ml-auto md:pl-8"}`}>
                  <h3 className="font-heading text-xs font-bold uppercase tracking-wider text-secondary">{item.phase}</h3>
                  <p className="font-subtitle text-sm text-muted-foreground">{item.desc}</p>
                </div>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      <SectionDivider variant="gold" />

      {/* Valores FIRST */}
      <section className="section-darker py-20">
        <div className="container">
          <motion.h2
            className="mb-4 text-center font-heading text-2xl font-bold uppercase tracking-wider md:text-3xl"
            variants={textReveal}
            initial="hidden"
            whileInView="visible"
            viewport={{ once: true }}
            custom={0}
          >
            Valores FIRST en <span className="text-gradient-gold">Acción</span>
          </motion.h2>
          <motion.p
            className="mb-4 text-center font-subtitle text-sm text-muted-foreground/70"
            initial={{ opacity: 0 }}
            whileInView={{ opacity: 1 }}
            viewport={{ once: true }}
            transition={{ delay: 0.3 }}
          >
            Haz clic en cada valor para descubrir cómo lo vivimos
          </motion.p>
          <motion.div className="mx-auto mb-12 h-1 w-16 rounded-full bg-primary" variants={scaleReveal} initial="hidden" whileInView="visible" viewport={{ once: true }} />
          <motion.div
            className="grid gap-5 sm:grid-cols-2 lg:grid-cols-3"
            variants={staggerContainer}
            initial="hidden"
            whileInView="visible"
            viewport={{ once: true }}
          >
            {valoresFIRST.map((v) => {
              const colorClass = v.color === "accent" ? "text-accent" : v.color === "secondary" ? "text-secondary" : "text-primary";
              const bgClass = v.color === "accent" ? "bg-accent/15" : v.color === "secondary" ? "bg-secondary/15" : "bg-primary/15";
              return (
                <motion.div key={v.slug} variants={staggerItem}>
                  <Link to={`/valores/${v.slug}`} className="group block glass-card-hover p-6 relative overflow-hidden">
                    <div className="absolute inset-0 bg-gradient-to-br from-primary/0 to-primary/0 group-hover:from-primary/5 group-hover:to-transparent transition-all duration-700" />
                    <div className="relative">
                      <div className="flex items-center gap-3 mb-3">
                        <motion.div
                          className={`flex h-12 w-12 items-center justify-center rounded-2xl ${bgClass}`}
                          whileHover={{ scale: 1.15, rotate: -5 }}
                          transition={{ type: "spring", stiffness: 300 }}
                        >
                          <v.icon className={`h-6 w-6 ${colorClass}`} />
                        </motion.div>
                        <h3 className="font-heading text-xs font-bold uppercase tracking-wider">{v.label}</h3>
                      </div>
                      <p className="mb-3 font-subtitle text-sm text-muted-foreground">{v.desc}</p>
                      <span className={`inline-flex items-center gap-1 font-subtitle text-xs font-semibold ${colorClass} group-hover:gap-2 transition-all`}>
                        Ver más <ArrowRight className="h-3 w-3" />
                      </span>
                    </div>
                  </Link>
                </motion.div>
              );
            })}
          </motion.div>
        </div>
      </section>

      <SectionDivider variant="gradient" />
      <Footer />
    </div>
  );
};

export default QuienesSomos;
