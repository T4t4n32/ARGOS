import React from "react";
import Navbar from "@/components/Navbar";
import Footer from "@/components/Footer";
import SectionDivider from "@/components/SectionDivider";
import { useTelemetry } from "@/hooks/useTelemetry";
import { motion } from "framer-motion";
import { Activity, Thermometer, Wind, Ruler, Wifi, WifiOff, AlertTriangle } from "lucide-react";

const Dashboard = () => {
  const { data, isConnected } = useTelemetry("ws://localhost:8765");

  // Fallbacks visuales para cuando no hay datos
  const temp = data?.t ?? 0;
  const gas = data?.g ?? 0;
  const distance = data?.d ?? 0;
  const risk = data?.risk ?? "UNKNOWN";
  
  // Colores dinámicos basados en el nivel de riesgo
  const getRiskColor = (level: string) => {
    switch (level) {
      case "NORMAL": return "text-green-400 drop-shadow-[0_0_10px_rgba(74,222,128,0.5)]";
      case "WARNING": return "text-yellow-400 drop-shadow-[0_0_10px_rgba(250,204,21,0.5)]";
      case "CRITICAL": return "text-red-500 drop-shadow-[0_0_10px_rgba(239,68,68,0.5)]";
      default: return "text-muted-foreground";
    }
  };

  const getRiskBg = (level: string) => {
    switch (level) {
      case "NORMAL": return "bg-green-500/10 border-green-500/30";
      case "WARNING": return "bg-yellow-500/10 border-yellow-500/30";
      case "CRITICAL": return "bg-red-500/10 border-red-500/30";
      default: return "bg-primary/5 border-primary/10";
    }
  };

  return (
    <div className="flex min-h-screen flex-col bg-background">
      <Navbar />

      <section className="section-dark relative flex flex-1 flex-col items-center justify-center py-20 overflow-hidden">
        {/* Background glow dinámico */}
        <div className="absolute inset-0 pointer-events-none flex items-center justify-center">
            <motion.div
              className={`h-[500px] w-[500px] rounded-full blur-[120px] transition-colors duration-1000 ${
                risk === "CRITICAL" ? "bg-red-500/20" : 
                risk === "WARNING" ? "bg-yellow-500/15" : 
                risk === "NORMAL" ? "bg-green-500/10" : "bg-primary/5"
              }`}
              animate={{ scale: [1, 1.1, 1] }}
              transition={{ duration: 4, repeat: Infinity }}
            />
        </div>

        <div className="container relative z-10 max-w-6xl">
          {/* Header del Dashboard */}
          <div className="mb-12 flex flex-col md:flex-row justify-between items-center gap-4">
            <div>
              <h1 className="font-heading text-4xl md:text-5xl font-black uppercase tracking-tight text-foreground drop-shadow-md">
                Telemetría <span className="text-gradient-gold">ARGOS</span>
              </h1>
              <p className="font-subtitle text-muted-foreground mt-2">
                Monitoreo ambiental en tiempo real
              </p>
            </div>
            
            <div className={`flex items-center gap-2 px-4 py-2 rounded-full border backdrop-blur-md transition-colors ${isConnected ? "border-green-500/50 bg-green-500/10 text-green-400" : "border-red-500/50 bg-red-500/10 text-red-400"}`}>
              {isConnected ? <Wifi className="w-5 h-5 animate-pulse" /> : <WifiOff className="w-5 h-5" />}
              <span className="font-subtitle font-bold text-sm tracking-widest uppercase">
                {isConnected ? "Enlace LoRa Activo" : "Buscando Señal"}
              </span>
            </div>
          </div>

          {/* Estado General (Riesgo) */}
          <motion.div 
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            className={`mb-8 w-full rounded-2xl border backdrop-blur-xl p-8 flex flex-col md:flex-row items-center justify-between gap-6 transition-all duration-700 ${getRiskBg(risk)}`}
          >
            <div className="flex items-center gap-6">
              <div className={`p-4 rounded-full bg-background/50 backdrop-blur-md border ${getRiskBg(risk)}`}>
                <AlertTriangle className={`w-10 h-10 ${getRiskColor(risk)}`} />
              </div>
              <div>
                <h3 className="font-heading text-sm text-muted-foreground font-bold tracking-widest uppercase">Evaluación de Entorno</h3>
                <h2 className={`font-heading text-4xl md:text-5xl font-black uppercase tracking-wider ${getRiskColor(risk)}`}>
                  {isConnected ? risk : "SIN DATOS"}
                </h2>
              </div>
            </div>
            {data?.source === "SIMULATION" && (
              <div className="px-4 py-2 bg-accent/20 border border-accent/50 rounded-md text-accent font-subtitle text-xs uppercase font-bold tracking-wider animate-pulse">
                Modo Simulación
              </div>
            )}
          </motion.div>

          {/* Tarjetas de Sensores */}
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            
            {/* Temperatura */}
            <motion.div 
              initial={{ opacity: 0, scale: 0.9 }}
              animate={{ opacity: 1, scale: 1 }}
              transition={{ delay: 0.1 }}
              className="glass-card-hover p-8 relative overflow-hidden group"
            >
              <div className="absolute top-0 right-0 p-6 opacity-20 group-hover:scale-110 transition-transform">
                <Thermometer className="w-24 h-24 text-primary" />
              </div>
              <h3 className="font-heading text-sm text-muted-foreground font-bold tracking-widest uppercase mb-4">Temperatura</h3>
              <div className="flex items-end gap-2">
                <span className="font-heading text-6xl font-black text-foreground drop-shadow-lg">
                  {temp > 0 ? temp.toFixed(1) : "--"}
                </span>
                <span className="font-subtitle text-2xl text-primary font-bold mb-1">°C</span>
              </div>
            </motion.div>

            {/* Gases Tóxicos */}
            <motion.div 
              initial={{ opacity: 0, scale: 0.9 }}
              animate={{ opacity: 1, scale: 1 }}
              transition={{ delay: 0.2 }}
              className="glass-card-hover p-8 relative overflow-hidden group"
            >
              <div className="absolute top-0 right-0 p-6 opacity-20 group-hover:scale-110 transition-transform">
                <Wind className="w-24 h-24 text-secondary" />
              </div>
              <h3 className="font-heading text-sm text-muted-foreground font-bold tracking-widest uppercase mb-4">Gases (MQ-135)</h3>
              <div className="flex items-end gap-2">
                <span className="font-heading text-6xl font-black text-foreground drop-shadow-lg">
                  {gas > 0 ? gas : "--"}
                </span>
                <span className="font-subtitle text-2xl text-secondary font-bold mb-1">ADC</span>
              </div>
              <p className="mt-2 text-xs text-muted-foreground/60 font-subtitle uppercase tracking-wider">Proxy Cualitativo de Calidad</p>
            </motion.div>

            {/* Distancia (LiDAR/ToF) */}
            <motion.div 
              initial={{ opacity: 0, scale: 0.9 }}
              animate={{ opacity: 1, scale: 1 }}
              transition={{ delay: 0.3 }}
              className="glass-card-hover p-8 relative overflow-hidden group"
            >
              <div className="absolute top-0 right-0 p-6 opacity-20 group-hover:scale-110 transition-transform">
                <Ruler className="w-24 h-24 text-accent" />
              </div>
              <h3 className="font-heading text-sm text-muted-foreground font-bold tracking-widest uppercase mb-4">Distancia Frontal</h3>
              <div className="flex items-end gap-2">
                <span className="font-heading text-6xl font-black text-foreground drop-shadow-lg">
                  {distance > 0 ? distance : "--"}
                </span>
                <span className="font-subtitle text-2xl text-accent font-bold mb-1">mm</span>
              </div>
            </motion.div>

          </div>
        </div>
      </section>

      <SectionDivider variant="gold" />
      <Footer />
    </div>
  );
};

export default Dashboard;
