import { useNavigate, useLocation } from "react-router-dom";
import { ArrowLeft, Home } from "lucide-react";
import { Button } from "@/components/ui/button";
import { motion } from "framer-motion";

const BackButton = () => {
  const navigate = useNavigate();
  const location = useLocation();

  const isDeepPage = location.pathname.split("/").filter(Boolean).length > 1;

  return (
    <motion.div
      className="container flex items-center gap-2 pt-4"
      initial={{ opacity: 0, x: -12 }}
      animate={{ opacity: 1, x: 0 }}
      transition={{ duration: 0.3, ease: "easeOut" }}
    >
      <Button
        variant="ghost"
        size="sm"
        onClick={() => navigate(-1)}
        className="group gap-2 rounded-full border border-border/50 bg-background/60 px-4 text-muted-foreground shadow-sm backdrop-blur-sm transition-all duration-200 hover:border-primary/30 hover:bg-primary/10 hover:text-foreground hover:shadow-md"
      >
        <ArrowLeft className="h-4 w-4 transition-transform duration-200 group-hover:-translate-x-0.5" />
        <span className="text-sm font-medium">Volver</span>
      </Button>

      {isDeepPage && (
        <Button
          variant="ghost"
          size="sm"
          onClick={() => navigate("/")}
          className="group gap-2 rounded-full border border-border/50 bg-background/60 px-4 text-muted-foreground shadow-sm backdrop-blur-sm transition-all duration-200 hover:border-primary/30 hover:bg-primary/10 hover:text-foreground hover:shadow-md"
        >
          <Home className="h-3.5 w-3.5" />
          <span className="text-sm font-medium">Inicio</span>
        </Button>
      )}
    </motion.div>
  );
};

export default BackButton;
