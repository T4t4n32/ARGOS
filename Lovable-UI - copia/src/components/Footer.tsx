import { Link } from "react-router-dom";
import { Instagram, Youtube } from "lucide-react";

const Footer = () => {
  return (
    <footer className="border-t border-primary/10 bg-background">
      <div className="container py-12">
        <div className="grid gap-8 md:grid-cols-3">
          <div className="flex flex-col gap-3">
            <img src="/logo.png" alt="Calibots Kairos" className="h-14 w-auto self-start drop-shadow-[0_0_15px_hsl(40_76%_50%/0.3)]" />
            <p className="font-subtitle text-sm text-muted-foreground">Calibots Kairos – FIRST LEGO League</p>
            <p className="font-subtitle text-xs text-muted-foreground/60">Club de Robótica · Colegio Comfandi El Prado</p>
          </div>

          <div>
            <h4 className="mb-3 font-heading text-xs font-bold uppercase tracking-[0.2em] text-primary">Navegación</h4>
            <ul className="space-y-2 font-subtitle text-sm">
              {[
                { label: "Inicio", path: "/" },
                { label: "Quiénes Somos", path: "/quienes-somos" },
                { label: "Proyecto Innovador", path: "/proyecto-innovador" },
                { label: "Juego del Robot", path: "/juego-del-robot" },
                { label: "Galería", path: "/galeria" },
                { label: "Contacto", path: "/contacto" },
              ].map((l) => (
                <li key={l.path}>
                  <Link to={l.path} className="text-muted-foreground transition-colors hover:text-primary">{l.label}</Link>
                </li>
              ))}
            </ul>
          </div>

          <div>
            <h4 className="mb-3 font-heading text-xs font-bold uppercase tracking-[0.2em] text-primary">Redes Sociales</h4>
            <div className="flex gap-3">
              <a href="https://www.instagram.com/calibots_?igsh=cjh4ZHlpZXE5bG4z" target="_blank" rel="noopener noreferrer" aria-label="Instagram" className="rounded-full border border-primary/20 bg-primary/5 p-2.5 transition-all duration-300 hover:bg-primary hover:text-primary-foreground hover:glow-gold">
                <Instagram className="h-5 w-5" />
              </a>
              <a href="#" aria-label="TikTok" className="rounded-full border border-primary/20 bg-primary/5 p-2.5 transition-all duration-300 hover:bg-primary hover:text-primary-foreground">
                <svg className="h-5 w-5" viewBox="0 0 24 24" fill="currentColor"><path d="M19.59 6.69a4.83 4.83 0 01-3.77-4.25V2h-3.45v13.67a2.89 2.89 0 01-2.88 2.5 2.89 2.89 0 01-2.89-2.89 2.89 2.89 0 012.89-2.89c.28 0 .54.04.79.1v-3.5a6.37 6.37 0 00-.79-.05A6.34 6.34 0 003.15 15.2a6.34 6.34 0 006.34 6.34 6.34 6.34 0 006.34-6.34V8.73a8.19 8.19 0 004.76 1.52V6.8a4.84 4.84 0 01-1-.11z"/></svg>
              </a>
              <a href="#" aria-label="YouTube" className="rounded-full border border-primary/20 bg-primary/5 p-2.5 transition-all duration-300 hover:bg-primary hover:text-primary-foreground">
                <Youtube className="h-5 w-5" />
              </a>
            </div>
          </div>
        </div>

        <div className="mt-10 border-t border-primary/10 pt-8 flex flex-col items-center gap-4">
          <div className="rounded-xl border border-primary/10 bg-primary/5 px-8 py-4 backdrop-blur">
            <img src="/logo.png" alt="Calibots Kairos" className="h-20 w-auto drop-shadow-[0_0_20px_hsl(40_76%_50%/0.3)]" />
          </div>
          <p className="font-subtitle text-sm text-muted-foreground/60">
            © {new Date().getFullYear()} Calibots Kairos. Todos los derechos reservados.
          </p>
        </div>
      </div>
    </footer>
  );
};

export default Footer;
