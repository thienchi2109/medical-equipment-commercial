import Image from "next/image";
import { cn } from "@/lib/utils";

interface LogoProps {
  size?: "sm" | "md" | "lg" | "xl";
  className?: string;
  priority?: boolean;
}

const LOGO_SIZES = {
  sm: "w-8 h-8",
  md: "w-12 h-12", 
  lg: "w-16 h-16",
  xl: "w-24 h-24"
};

const LOGO_IMAGE_SIZES = {
  sm: "32px",
  md: "48px",
  lg: "64px", 
  xl: "96px"
};

export const Logo = ({ size = "lg", className, priority = false }: LogoProps) => (
  <div className={cn(
    "relative aspect-square overflow-hidden rounded-lg shadow-sm bg-white/5 backdrop-blur-sm border border-white/10",
    LOGO_SIZES[size],
    className
  )}>
    <Image
      src="https://i.postimg.cc/nrXWkxVq/2e5964f6128d9ad3c39c.jpg"
      alt="Logo CDC"
      fill
      className="object-cover object-center transition-transform duration-200 hover:scale-105"
      priority={priority}
      sizes={`(max-width: 768px) ${LOGO_IMAGE_SIZES[size]}, ${LOGO_IMAGE_SIZES[size]}`}
    />
  </div>
);
