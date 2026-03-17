import { useState } from "react";
import { Link, useLocation } from "react-router-dom";
import { Menu, X } from "lucide-react";
import { Button } from "@/components/ui/button";

const navItems = [
  { label: "Inicio", path: "/" },
  { label: "Quiénes Somos", path: "/quienes-somos" },
  { label: "Proyecto Innovador", path: "/proyecto-innovador" },
  { label: "Juego del Robot", path: "/juego-del-robot" },
  { label: "Galería", path: "/galeria" },
  { label: "Contacto", path: "/contacto" },
];

const Navbar = () => {
  const [open, setOpen] = useState(false);
  const location = useLocation();

  return (
    <header className="sticky top-0 z-50 w-full border-b border-primary/10 bg-background/70 backdrop-blur-2xl">
      <div className="container flex h-16 items-center justify-between">
        <Link to="/" className="flex items-center gap-3">
          <img src="/logo.png" alt="Calibots Kairos" className="h-10 w-auto drop-shadow-[0_0_10px_hsl(40_76%_50%/0.4)]" />
          <span className="hidden font-heading text-sm font-bold tracking-wider text-foreground sm:inline uppercase">
            Calibots Kairos
          </span>
        </Link>

        {/* Desktop nav */}
        <nav className="hidden items-center gap-1 lg:flex">
          {navItems.map((item) => (
            <Link
              key={item.path}
              to={item.path}
              className={`rounded-md px-3 py-2 font-subtitle text-sm font-medium uppercase tracking-wide transition-all duration-300 ${
                location.pathname === item.path
                  ? "text-primary glow-gold bg-primary/10"
                  : "text-muted-foreground hover:text-primary hover:bg-primary/5"
              }`}
            >
              {item.label}
            </Link>
          ))}
        </nav>

        <Button
          variant="ghost"
          size="icon"
          className="lg:hidden text-foreground"
          onClick={() => setOpen(!open)}
          aria-label="Menú"
        >
          {open ? <X className="h-5 w-5" /> : <Menu className="h-5 w-5" />}
        </Button>
      </div>

      {open && (
        <nav className="border-t border-primary/10 bg-background/95 backdrop-blur-xl px-4 pb-4 lg:hidden">
          {navItems.map((item) => (
            <Link
              key={item.path}
              to={item.path}
              onClick={() => setOpen(false)}
              className={`block rounded-md px-3 py-3 font-subtitle text-sm font-medium uppercase tracking-wide transition-all duration-300 ${
                location.pathname === item.path
                  ? "text-primary"
                  : "text-muted-foreground hover:text-primary"
              }`}
            >
              {item.label}
            </Link>
          ))}
        </nav>
      )}
    </header>
  );
};

export default Navbar;
