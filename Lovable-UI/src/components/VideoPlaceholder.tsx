import { Video } from "lucide-react";

interface VideoPlaceholderProps {
  label?: string;
  className?: string;
}

const VideoPlaceholder = ({
  label = "🎥 Video aquí",
  className = "",
}: VideoPlaceholderProps) => {
  return (
    <div
      className={`aspect-video flex flex-col items-center justify-center rounded-lg border-2 border-dashed border-muted-foreground/30 bg-muted/50 text-muted-foreground ${className}`}
    >
      <Video className="mb-2 h-10 w-10 opacity-40" />
      <span className="text-sm font-medium opacity-60">{label}</span>
    </div>
  );
};

export default VideoPlaceholder;
