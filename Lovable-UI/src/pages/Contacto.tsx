import { motion } from "framer-motion";
import Navbar from "@/components/Navbar";
import BackButton from "@/components/BackButton";
import Footer from "@/components/Footer";
import SectionDivider from "@/components/SectionDivider";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Label } from "@/components/ui/label";
import { Instagram, Youtube, MapPin, Mail, School } from "lucide-react";
import { textReveal, slideFromLeft, slideFromRight, scaleReveal } from "@/lib/animations";

const Contacto = () => {
  return (
    <div className="flex min-h-screen flex-col bg-background">
      <Navbar />
      <BackButton />

      <section className="relative py-24 overflow-hidden section-dark">
        <div className="absolute inset-0 flex items-center justify-center pointer-events-none">
          <motion.div
            className="h-[400px] w-[400px] rounded-full bg-accent/8 blur-[100px]"
            animate={{ scale: [1, 1.2, 1] }}
            transition={{ duration: 5, repeat: Infinity, ease: "easeInOut" }}
          />
        </div>
        <div className="container relative z-10 text-center">
          <motion.h1 className="font-heading text-3xl font-black uppercase tracking-wider md:text-5xl lg:text-6xl" variants={textReveal} initial="hidden" animate="visible" custom={0}>
            <span className="text-gradient-crimson">Contacto</span>
          </motion.h1>
          <motion.p className="mt-5 font-subtitle text-lg text-muted-foreground/80" initial={{ opacity: 0, filter: "blur(6px)" }} animate={{ opacity: 1, filter: "blur(0px)" }} transition={{ delay: 0.4 }}>
            ¿Quieres saber más? ¡Escríbenos!
          </motion.p>
        </div>
      </section>

      <SectionDivider variant="crimson" />

      <section className="section-darker py-20">
        <div className="container">
          <div className="grid gap-12 md:grid-cols-2">
            <motion.div variants={slideFromLeft} initial="hidden" whileInView="visible" viewport={{ once: true }} custom={0}>
              <h2 className="mb-8 font-heading text-lg font-bold uppercase tracking-wider">Envíanos un mensaje</h2>
              <form className="space-y-5" onSubmit={(e) => e.preventDefault()}>
                <motion.div initial={{ opacity: 0, x: -20 }} whileInView={{ opacity: 1, x: 0 }} viewport={{ once: true }} transition={{ delay: 0.1 }}>
                  <Label htmlFor="name" className="font-subtitle text-sm uppercase tracking-wider">Nombre</Label>
                  <Input id="name" placeholder="Tu nombre" className="mt-2 bg-card/50 border-primary/20 font-subtitle" />
                </motion.div>
                <motion.div initial={{ opacity: 0, x: -20 }} whileInView={{ opacity: 1, x: 0 }} viewport={{ once: true }} transition={{ delay: 0.2 }}>
                  <Label htmlFor="email" className="font-subtitle text-sm uppercase tracking-wider">Correo electrónico</Label>
                  <Input id="email" type="email" placeholder="tu@correo.com" className="mt-2 bg-card/50 border-primary/20 font-subtitle" />
                </motion.div>
                <motion.div initial={{ opacity: 0, x: -20 }} whileInView={{ opacity: 1, x: 0 }} viewport={{ once: true }} transition={{ delay: 0.3 }}>
                  <Label htmlFor="message" className="font-subtitle text-sm uppercase tracking-wider">Mensaje</Label>
                  <Textarea id="message" placeholder="Escribe tu mensaje..." rows={5} className="mt-2 bg-card/50 border-primary/20 font-subtitle" />
                </motion.div>
                <motion.div initial={{ opacity: 0, y: 10 }} whileInView={{ opacity: 1, y: 0 }} viewport={{ once: true }} transition={{ delay: 0.4 }}>
                  <Button type="submit" className="bg-primary text-primary-foreground font-subtitle font-bold uppercase tracking-wider glow-gold hover:scale-105 transition-all duration-300">Enviar mensaje</Button>
                </motion.div>
              </form>
            </motion.div>

            <motion.div variants={slideFromRight} initial="hidden" whileInView="visible" viewport={{ once: true }} custom={0} className="space-y-8">
              <div>
                <h2 className="mb-5 font-heading text-lg font-bold uppercase tracking-wider">Información</h2>
                <ul className="space-y-4 font-subtitle text-muted-foreground">
                  <motion.li className="flex items-start gap-3" initial={{ opacity: 0, x: 20 }} whileInView={{ opacity: 1, x: 0 }} viewport={{ once: true }} transition={{ delay: 0.2 }}>
                    <School className="mt-0.5 h-5 w-5 shrink-0 text-secondary" /><span>Colegio Comfandi El Prado<br />Club de Robótica Calibots Kairos</span>
                  </motion.li>
                  <motion.li className="flex items-start gap-3" initial={{ opacity: 0, x: 20 }} whileInView={{ opacity: 1, x: 0 }} viewport={{ once: true }} transition={{ delay: 0.3 }}>
                    <MapPin className="mt-0.5 h-5 w-5 shrink-0 text-secondary" /><span>Cali, Colombia</span>
                  </motion.li>
                  <motion.li className="flex items-start gap-3" initial={{ opacity: 0, x: 20 }} whileInView={{ opacity: 1, x: 0 }} viewport={{ once: true }} transition={{ delay: 0.4 }}>
                    <Mail className="mt-0.5 h-5 w-5 shrink-0 text-secondary" /><span>contacto@calibotskairos.com</span>
                  </motion.li>
                </ul>
              </div>
              <motion.div initial={{ opacity: 0, y: 15 }} whileInView={{ opacity: 1, y: 0 }} viewport={{ once: true }} transition={{ delay: 0.5 }}>
                <h3 className="mb-4 font-heading text-sm font-bold uppercase tracking-wider">Redes Sociales</h3>
                <div className="flex gap-3">
                  <a href="https://www.instagram.com/calibots_?igsh=cjh4ZHlpZXE5bG4z" target="_blank" rel="noopener noreferrer" className="flex items-center gap-2 rounded-full border border-primary/20 bg-primary/5 px-4 py-2 font-subtitle text-sm font-medium transition-all duration-300 hover:bg-primary hover:text-primary-foreground hover:scale-105"><Instagram className="h-4 w-4" /> Instagram</a>
                  <a href="#" className="flex items-center gap-2 rounded-full border border-primary/20 bg-primary/5 px-4 py-2 font-subtitle text-sm font-medium transition-all duration-300 hover:bg-primary hover:text-primary-foreground hover:scale-105">
                    <svg className="h-4 w-4" viewBox="0 0 24 24" fill="currentColor"><path d="M19.59 6.69a4.83 4.83 0 01-3.77-4.25V2h-3.45v13.67a2.89 2.89 0 01-2.88 2.5 2.89 2.89 0 01-2.89-2.89 2.89 2.89 0 012.89-2.89c.28 0 .54.04.79.1v-3.5a6.37 6.37 0 00-.79-.05A6.34 6.34 0 003.15 15.2a6.34 6.34 0 006.34 6.34 6.34 6.34 0 006.34-6.34V8.73a8.19 8.19 0 004.76 1.52V6.8a4.84 4.84 0 01-1-.11z"/></svg> TikTok
                  </a>
                  <a href="#" className="flex items-center gap-2 rounded-full border border-primary/20 bg-primary/5 px-4 py-2 font-subtitle text-sm font-medium transition-all duration-300 hover:bg-primary hover:text-primary-foreground hover:scale-105"><Youtube className="h-4 w-4" /> YouTube</a>
                </div>
              </motion.div>
              <motion.div
                initial={{ opacity: 0, scale: 0.95, filter: "blur(6px)" }}
                whileInView={{ opacity: 1, scale: 1, filter: "blur(0px)" }}
                viewport={{ once: true }}
                transition={{ delay: 0.6, duration: 0.7 }}
              >
                <h3 className="mb-3 font-heading text-sm font-bold uppercase tracking-wider">Ubicación</h3>
                <div className="flex aspect-video items-center justify-center rounded-lg border border-primary/10 bg-card/50 text-muted-foreground">
                  <div className="text-center"><MapPin className="mx-auto mb-2 h-8 w-8 opacity-40" /><span className="font-subtitle text-sm opacity-60">🗺️ Mapa de Google Maps aquí</span></div>
                </div>
              </motion.div>
            </motion.div>
          </div>
        </div>
      </section>

      <SectionDivider variant="gradient" />
      <Footer />
    </div>
  );
};

export default Contacto;
