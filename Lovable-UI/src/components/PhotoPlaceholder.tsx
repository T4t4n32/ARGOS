import { Camera } from "lucide-react";

interface PhotoPlaceholderProps {
  label?: string;
  className?: string;
  aspectRatio?: "square" | "video" | "portrait";
}

const PhotoPlaceholder = ({
  label = "📷 Foto aquí",
  className = "",
  aspectRatio = "square",
}: PhotoPlaceholderProps) => {
  const ratioClass = {
    square: "aspect-square",
    video: "aspect-video",
    portrait: "aspect-[3/4]",
  }[aspectRatio];

  return (
    <div
      className={`${ratioClass} flex flex-col items-center justify-center rounded-lg border-2 border-dashed border-muted-foreground/30 bg-muted/50 text-muted-foreground ${className}`}
    >
      <Camera className="mb-2 h-8 w-8 opacity-40" />
      <span className="text-sm font-medium opacity-60">{label}</span>
    </div>
  );
};

export default PhotoPlaceholder;
