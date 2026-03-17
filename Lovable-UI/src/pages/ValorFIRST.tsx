import { useParams, Link } from "react-router-dom";
import { motion } from "framer-motion";
import Navbar from "@/components/Navbar";
import BackButton from "@/components/BackButton";
import Footer from "@/components/Footer";
import PhotoPlaceholder from "@/components/PhotoPlaceholder";
import { fadeUp } from "@/lib/animations";
import { Button } from "@/components/ui/button";
import { ArrowLeft, Lightbulb, Search, Zap, Users, Heart, PartyPopper } from "lucide-react";

const valoresData: Record<string, {
  title: string;
  icon: typeof Lightbulb;
  color: string;
  description: string;
  howWeApply: string;
  quote: string;
}> = {
  descubrimiento: {
    title: "Descubrimiento",
    icon: Search,
    color: "primary",
    description: "Exploramos nuevas habilidades, ideas y conceptos. En FIRST LEGO League, el descubrimiento es el motor que impulsa a los equipos a investigar problemas reales y encontrar soluciones creativas.",
    howWeApply: "En CaliBots Kairos, cada temporada es una oportunidad para descubrir algo nuevo. Con ARGOS, descubrimos el fascinante mundo de la espeleología, la arqueología y los desafíos que enfrentan los científicos en cuevas. Investigamos con expertos, visitamos museos y aprendimos sobre sensores y robótica aplicada.",
    quote: "\"Descubrir es ver lo que todos han visto y pensar lo que nadie ha pensado.\" — Albert Szent-Györgyi",
  },
  innovacion: {
    title: "Innovación",
    icon: Lightbulb,
    color: "accent",
    description: "Usamos creatividad y perseverancia para resolver problemas. La innovación en FIRST LEGO League significa pensar diferente y atreverse a crear soluciones que no existían antes.",
    howWeApply: "ARGOS nació de una pregunta: ¿cómo proteger a los arqueólogos en cuevas peligrosas? Iteramos desde un prototipo V1 básico hasta un V2 con mejor suspensión y sensores de gas. Cada versión fue mejor porque aprendimos de nuestros errores y buscamos retroalimentación de expertos.",
    quote: "\"La innovación distingue a un líder de un seguidor.\" — Steve Jobs",
  },
  impacto: {
    title: "Impacto",
    icon: Zap,
    color: "secondary",
    description: "Aplicamos lo que aprendemos para mejorar nuestro mundo. En FIRST LEGO League, el impacto va más allá de la competencia: se trata de crear cambio real en nuestras comunidades.",
    howWeApply: "Nuestro proyecto busca impactar la seguridad de arqueólogos y espeleólogos en todo el mundo. Además, creamos un juego educativo para que niños más pequeños aprendan sobre la importancia de preservar el patrimonio arqueológico. Queremos que nuestra solución trascienda la competencia.",
    quote: "\"El verdadero impacto se mide en las vidas que tocamos.\"",
  },
  inclusion: {
    title: "Inclusión",
    icon: Heart,
    color: "primary",
    description: "Nos respetamos unos a otros y valoramos nuestras diferencias. FIRST LEGO League celebra la diversidad y cree que todos merecen la oportunidad de participar y contribuir.",
    howWeApply: "En CaliBots Kairos, cada integrante aporta algo único. Valoramos las ideas de todos, sin importar su experiencia previa. Trabajamos para que cada voz sea escuchada y cada talento sea aprovechado. La diversidad de nuestro equipo es nuestra mayor fortaleza.",
    quote: "\"La fortaleza está en las diferencias, no en las similitudes.\" — Stephen Covey",
  },
  "trabajo-en-equipo": {
    title: "Trabajo en Equipo",
    icon: Users,
    color: "secondary",
    description: "Somos más fuertes cuando trabajamos juntos. En FIRST LEGO League, ningún logro es individual: todo se construye como equipo, desde la investigación hasta la presentación final.",
    howWeApply: "Nuestros 10 estudiantes y 2 coaches trabajan como una unidad. Dividimos tareas según fortalezas: algunos investigan, otros programan, otros diseñan y construyen. Nos reunimos semanalmente para compartir avances y tomar decisiones juntos. El éxito de ARGOS es el éxito de todo el equipo.",
    quote: "\"Ninguno de nosotros es tan inteligente como todos nosotros juntos.\" — Ken Blanchard",
  },
  diversion: {
    title: "Diversión",
    icon: PartyPopper,
    color: "accent",
    description: "¡Disfrutamos y celebramos lo que hacemos! En FIRST LEGO League, aprender debe ser emocionante. La diversión es el combustible que mantiene viva la pasión por la ciencia y la tecnología.",
    howWeApply: "En CaliBots Kairos nos divertimos en cada paso del proceso. Desde las sesiones de lluvia de ideas hasta las pruebas del robot, cada momento es una oportunidad para reír, celebrar y disfrutar juntos. Porque cuando te diviertes, aprendes más y mejor.",
    quote: "\"La diversión es la forma más elevada de investigación.\" — Albert Einstein",
  },
};

const ValorFIRST = () => {
  const { slug } = useParams<{ slug: string }>();
  const valor = slug ? valoresData[slug] : null;

  if (!valor) {
    return (
      <div className="flex min-h-screen flex-col bg-background">
        <Navbar />
        <BackButton />
        <div className="container flex flex-1 flex-col items-center justify-center gap-4 py-20">
          <h1 className="font-heading text-2xl font-bold uppercase tracking-wider">Valor no encontrado</h1>
          <Button asChild><Link to="/quienes-somos">Volver</Link></Button>
        </div>
        <Footer />
      </div>
    );
  }

  const IconComp = valor.icon;
  const colorClass = valor.color === "accent" ? "text-accent" : valor.color === "secondary" ? "text-secondary" : "text-primary";
  const bgColorClass = valor.color === "accent" ? "bg-accent/15" : valor.color === "secondary" ? "bg-secondary/15" : "bg-primary/15";

  return (
    <div className="flex min-h-screen flex-col bg-background">
      <Navbar />
      <BackButton />

      {/* Hero */}
      <section className="relative py-16 overflow-hidden section-dark">
        <div className="absolute inset-0 flex items-center justify-center">
          <div className={`h-[300px] w-[300px] rounded-full ${valor.color === "accent" ? "bg-accent/8" : valor.color === "secondary" ? "bg-secondary/8" : "bg-primary/8"} blur-[80px]`} />
        </div>
        <div className="container relative z-10 text-center">
          <motion.div initial={{ opacity: 0, scale: 0.8 }} animate={{ opacity: 1, scale: 1 }} transition={{ duration: 0.5 }}>
            <div className={`mx-auto mb-4 flex h-20 w-20 items-center justify-center rounded-full ${bgColorClass}`}>
              <IconComp className={`h-10 w-10 ${colorClass}`} />
            </div>
          </motion.div>
          <motion.h1 className="font-heading text-3xl font-black uppercase tracking-wider md:text-5xl" initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.2 }}>
            {valor.title}
          </motion.h1>
          <motion.p className="mt-2 font-subtitle text-sm uppercase tracking-[0.2em] text-muted-foreground" initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 0.4 }}>
            Valores FIRST en Acción
          </motion.p>
        </div>
      </section>

      {/* Content */}
      <section className="section-darker py-16">
        <div className="container">
          <div className="mx-auto max-w-3xl space-y-12">
            <motion.div variants={fadeUp} initial="hidden" whileInView="visible" viewport={{ once: true }} custom={0}>
              <h2 className="mb-4 font-heading text-lg font-bold uppercase tracking-wider">¿Qué significa este valor?</h2>
              <p className="font-subtitle text-muted-foreground leading-relaxed">{valor.description}</p>
            </motion.div>

            <motion.div variants={fadeUp} initial="hidden" whileInView="visible" viewport={{ once: true }} custom={1} className="glass-card p-6">
              <h2 className="mb-4 font-heading text-lg font-bold uppercase tracking-wider">Cómo lo aplicamos en CaliBots Kairos</h2>
              <p className="font-subtitle text-muted-foreground leading-relaxed">{valor.howWeApply}</p>
            </motion.div>

            <motion.div variants={fadeUp} initial="hidden" whileInView="visible" viewport={{ once: true }} custom={2}>
              <h2 className="mb-6 font-heading text-lg font-bold uppercase tracking-wider">Evidencia Visual</h2>
              <div className="grid gap-4 sm:grid-cols-2">
                <PhotoPlaceholder aspectRatio="video" label={`📷 ${valor.title} - Foto 1`} />
                <PhotoPlaceholder aspectRatio="video" label={`📷 ${valor.title} - Foto 2`} />
                <PhotoPlaceholder aspectRatio="video" label={`📷 ${valor.title} - Foto 3`} />
                <PhotoPlaceholder aspectRatio="video" label={`📷 ${valor.title} - Foto 4`} />
              </div>
            </motion.div>

            <motion.div variants={fadeUp} initial="hidden" whileInView="visible" viewport={{ once: true }} custom={3} className="glass-card p-8 text-center glow-gold">
              <p className="font-subtitle text-lg italic text-muted-foreground">{valor.quote}</p>
            </motion.div>

            <div className="text-center">
              <Button asChild variant="outline" className="gap-2 border-primary/30 font-subtitle uppercase tracking-wider hover:bg-primary/10">
                <Link to="/quienes-somos"><ArrowLeft className="h-4 w-4" /> Volver a Quiénes Somos</Link>
              </Button>
            </div>
          </div>
        </div>
      </section>

      <Footer />
    </div>
  );
};

export default ValorFIRST;
