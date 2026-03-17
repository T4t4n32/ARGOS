import Navbar from "@/components/Navbar";
import BackButton from "@/components/BackButton";
import Footer from "@/components/Footer";
import SectionDivider from "@/components/SectionDivider";
import HeroSection from "@/components/proyecto/HeroSection";
import FiveKeysSection from "@/components/proyecto/FiveKeysSection";
import JustificacionSection from "@/components/proyecto/JustificacionSection";
import ConceptoSection from "@/components/proyecto/ConceptoSection";
import NombreSection from "@/components/proyecto/NombreSection";
import ObjetivosSection from "@/components/proyecto/ObjetivosSection";
import ProblematicasSection from "@/components/proyecto/ProblematicasSection";
import PaleontologiaImpactoSection from "@/components/proyecto/PaleontologiaImpactoSection";
import CasosRealesSection from "@/components/proyecto/CasosRealesSection";
import EvolucionSection from "@/components/proyecto/EvolucionSection";
import TecnologiaSection from "@/components/proyecto/TecnologiaSection";
import JuegoSection from "@/components/proyecto/JuegoSection";
import TimelineSection from "@/components/proyecto/TimelineSection";

const ProyectoInnovador = () => {
  return (
    <div className="flex min-h-screen flex-col bg-background">
      <Navbar />
      <BackButton />
      <HeroSection />
      <SectionDivider variant="gold" />
      <FiveKeysSection />
      <SectionDivider variant="teal" />
      <JustificacionSection />
      <SectionDivider variant="crimson" />
      <ConceptoSection />
      <SectionDivider variant="gold" />
      <NombreSection />
      <SectionDivider variant="teal" />
      <ObjetivosSection />
      <SectionDivider variant="crimson" />
      <ProblematicasSection />
      <SectionDivider variant="gradient" />
      <PaleontologiaImpactoSection />
      <SectionDivider variant="gold" />
      <CasosRealesSection />
      <SectionDivider variant="teal" />
      <EvolucionSection />
      <SectionDivider variant="crimson" />
      <TecnologiaSection />
      <SectionDivider variant="gold" />
      <JuegoSection />
      <SectionDivider variant="gradient" />
      <TimelineSection />
      <Footer />
    </div>
  );
};

export default ProyectoInnovador;
