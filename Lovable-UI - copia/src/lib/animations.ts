import type { Variants } from "framer-motion";

// Basic fade up (preserved)
export const fadeUp: Variants = {
  hidden: { opacity: 0, y: 30 },
  visible: (i: number) => ({
    opacity: 1,
    y: 0,
    transition: { delay: i * 0.12, duration: 0.6, ease: [0.25, 0.46, 0.45, 0.94] },
  }),
};

// Cinematic slide from left
export const slideFromLeft: Variants = {
  hidden: { opacity: 0, x: -80, filter: "blur(8px)" },
  visible: (i: number = 0) => ({
    opacity: 1,
    x: 0,
    filter: "blur(0px)",
    transition: { delay: i * 0.15, duration: 0.8, ease: [0.16, 1, 0.3, 1] },
  }),
};

// Cinematic slide from right
export const slideFromRight: Variants = {
  hidden: { opacity: 0, x: 80, filter: "blur(8px)" },
  visible: (i: number = 0) => ({
    opacity: 1,
    x: 0,
    filter: "blur(0px)",
    transition: { delay: i * 0.15, duration: 0.8, ease: [0.16, 1, 0.3, 1] },
  }),
};

// Scale up with blur (cinematic reveal)
export const scaleReveal: Variants = {
  hidden: { opacity: 0, scale: 0.8, filter: "blur(12px)" },
  visible: (i: number = 0) => ({
    opacity: 1,
    scale: 1,
    filter: "blur(0px)",
    transition: { delay: i * 0.15, duration: 0.9, ease: [0.16, 1, 0.3, 1] },
  }),
};

// Stagger container
export const staggerContainer: Variants = {
  hidden: { opacity: 0 },
  visible: {
    opacity: 1,
    transition: { staggerChildren: 0.1, delayChildren: 0.2 },
  },
};

// Stagger item
export const staggerItem: Variants = {
  hidden: { opacity: 0, y: 25, filter: "blur(4px)" },
  visible: {
    opacity: 1,
    y: 0,
    filter: "blur(0px)",
    transition: { duration: 0.6, ease: [0.16, 1, 0.3, 1] },
  },
};

// Dramatic text reveal (word by word feel)
export const textReveal: Variants = {
  hidden: { opacity: 0, y: 50, rotateX: -15 },
  visible: (i: number = 0) => ({
    opacity: 1,
    y: 0,
    rotateX: 0,
    transition: { delay: i * 0.1, duration: 0.7, ease: [0.16, 1, 0.3, 1] },
  }),
};

// Flip in from bottom (3D card flip)
export const flipIn: Variants = {
  hidden: { opacity: 0, rotateX: 25, y: 40, transformPerspective: 800 },
  visible: (i: number = 0) => ({
    opacity: 1,
    rotateX: 0,
    y: 0,
    transition: { delay: i * 0.12, duration: 0.8, ease: [0.16, 1, 0.3, 1] },
  }),
};

// Zoom in from far
export const zoomIn: Variants = {
  hidden: { opacity: 0, scale: 0.5 },
  visible: (i: number = 0) => ({
    opacity: 1,
    scale: 1,
    transition: { delay: i * 0.1, duration: 1, ease: [0.16, 1, 0.3, 1] },
  }),
};

// Fade in with no movement (subtle)
export const fadeIn: Variants = {
  hidden: { opacity: 0 },
  visible: (i: number = 0) => ({
    opacity: 1,
    transition: { delay: i * 0.15, duration: 0.8 },
  }),
};

// Glitch-like horizontal shake entrance
export const glitchIn: Variants = {
  hidden: { opacity: 0, x: -20, skewX: -5 },
  visible: (i: number = 0) => ({
    opacity: 1,
    x: 0,
    skewX: 0,
    transition: { delay: i * 0.1, duration: 0.5, ease: [0.16, 1, 0.3, 1] },
  }),
};

// Draw line (for decorative elements)
export const drawLine: Variants = {
  hidden: { scaleX: 0, originX: 0 },
  visible: {
    scaleX: 1,
    transition: { duration: 1.2, ease: [0.16, 1, 0.3, 1] },
  },
};
