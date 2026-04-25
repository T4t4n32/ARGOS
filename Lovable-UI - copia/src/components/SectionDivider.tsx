import { motion } from "framer-motion";
import { drawLine } from "@/lib/animations";

interface SectionDividerProps {
  variant?: "gold" | "teal" | "crimson" | "gradient";
  className?: string;
}

const SectionDivider = ({ variant = "gold", className = "" }: SectionDividerProps) => {
  const colors = {
    gold: "from-transparent via-primary/50 to-transparent",
    teal: "from-transparent via-secondary/50 to-transparent",
    crimson: "from-transparent via-accent/50 to-transparent",
    gradient: "from-primary/30 via-secondary/50 to-accent/30",
  };

  return (
    <div className={`relative py-4 overflow-hidden ${className}`}>
      <motion.div
        className={`mx-auto h-px w-3/4 max-w-2xl bg-gradient-to-r ${colors[variant]}`}
        variants={drawLine}
        initial="hidden"
        whileInView="visible"
        viewport={{ once: true }}
      />
      {/* Center dot */}
      <motion.div
        className={`absolute left-1/2 top-1/2 -translate-x-1/2 -translate-y-1/2 h-2 w-2 rounded-full ${
          variant === "gold" ? "bg-primary" : variant === "teal" ? "bg-secondary" : variant === "crimson" ? "bg-accent" : "bg-primary"
        }`}
        initial={{ scale: 0, opacity: 0 }}
        whileInView={{ scale: 1, opacity: 1 }}
        viewport={{ once: true }}
        transition={{ delay: 0.5, duration: 0.4, ease: [0.16, 1, 0.3, 1] }}
        style={{
          boxShadow: variant === "gold"
            ? "0 0 12px hsl(40 76% 50% / 0.6)"
            : variant === "teal"
            ? "0 0 12px hsl(160 40% 45% / 0.6)"
            : "0 0 12px hsl(8 70% 52% / 0.6)",
        }}
      />
    </div>
  );
};

export default SectionDivider;
