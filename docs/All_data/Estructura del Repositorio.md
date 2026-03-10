## Plataforma Digital CALIBOTS KAIROS – FLL UNEARTHED 2025–2026

---

## 1. Principios de la Estructura

Esta estructura está diseñada para cumplir cuatro objetivos clave:

1. **Claridad**: cualquier integrante del equipo puede entender dónde va cada cosa.
    
2. **Separación de responsabilidades**: contenido ≠ código ≠ recursos pesados.
    
3. **Escalabilidad**: reutilizable para futuras temporadas FLL.
    
4. **Compatibilidad**: pensada para Next.js + CMS + 3D embebido.
    

---

## 2. Árbol General del Repositorio

```
calibots-kairos-platform/
│
├── README.md                     # README estratégico (ya creado)
├── README.tech.md                # README técnico (build, deploy, CMS)
├── README.team.md                # README interno del equipo
│
├── package.json                  # Dependencias y scripts
├── next.config.js                # Configuración Next.js
├── vercel.json                   # Configuración de despliegue
│
├── public/                       # Recursos públicos estáticos
│   ├── images/
│   │   ├── team/                 # Fotos de integrantes
│   │   ├── robot/                # Fotos del robot
│   │   ├── attachments/          # Fotos de attachments
│   │   ├── core-values/           # Evidencias visuales valores FLL
│   │   └── gallery/              # Galería general
│   │
│   ├── videos/
│   │   ├── hero/                 # Video principal
│   │   ├── robot/                # Clips misiones
│   │   └── innovation/           # Clips del proyecto
│   │
│   ├── icons/                    # Íconos SVG
│   ├── logos/                    # Logos del equipo/proyecto
│   └── documents/                # PDFs (dossier jueces, etc.)
│
├── content/                      # CONTENIDO EDITABLE (CMS / Markdown)
│   ├── home/
│   │   ├── hero.md
│   │   ├── team.md
│   │   ├── timeline.md
│   │   └── core-values.md
│   │
│   ├── innovation/
│   │   ├── overview.md
│   │   ├── research.md
│   │   ├── solution.md
│   │   ├── iteration.md
│   │   ├── technology.md
│   │   └── impact.md
│   │
│   ├── robot/
│   │   ├── philosophy.md
│   │   ├── base-robot.md
│   │   └── attachments/
│   │       ├── attachment-01.md
│   │       ├── attachment-02.md
│   │       └── ...
│   │
│   ├── gallery/
│   │   └── gallery.json          # Metadata galería
│   │
│   └── changelog/
│       └── internal.md           # Bitácora privada
│
├── models3D/                     # MODELOS 3D (no públicos directamente)
│   ├── robot/
│   │   └── robot-final.glb
│   ├── attachments/
│   │   ├── attachment-01.glb
│   │   └── attachment-02.glb
│   └── innovation/
│       └── prototype.glb
│
├── components/                   # COMPONENTES REACT
│   ├── layout/
│   │   ├── Navbar.tsx
│   │   ├── Footer.tsx
│   │   └── SectionWrapper.tsx
│   │
│   ├── home/
│   │   ├── Hero.tsx
│   │   ├── TeamGrid.tsx
│   │   ├── Timeline.tsx
│   │   └── CoreValues.tsx
│   │
│   ├── innovation/
│   ├── robot/
│   ├── gallery/
│   └── ui/                       # Botones, cards, modals
│
├── pages/                        # Rutas (Next.js Pages Router)
│   ├── index.tsx                 # SPA principal
│   └── _app.tsx
│
├── styles/
│   ├── globals.css
│   └── theme.css
│
├── lib/
│   ├── content-loader.ts         # Lectura Markdown
│   ├── cms-config.ts             # Config CMS
│   └── constants.ts
│
├── cms/
│   └── config.yml                # Configuración Decap CMS
│
└── scripts/
    ├── optimize-images.js
    └── validate-content.js
```

---

## 3. Qué toca cada rol (MUY IMPORTANTE)

### 👩‍💻 Programadores

- `/components`
    
- `/pages`
    
- `/lib`
    
- `/styles`
    
- `/scripts`
    

❌ **NO tocar directamente:**

- `/content`
    
- `/public/images` (salvo ajustes técnicos)
    

---

### 🧠 Investigadores / Documentadores

- `/content/innovation`
    
- `/content/home`
    
- `/content/robot`
    

❌ **NO tocar:**

- `/components`
    
- `/pages`
    

---

### 🎨 Diseño / Multimedia

- `/public/images`
    
- `/public/videos`
    
- `/public/logos`
    

Regla:

> Todo archivo debe estar optimizado antes de subir.

---

### 🧑‍🏫 Coaches

- Revisión de `/content`
    
- Validación de mensajes
    
- Control de coherencia FLL
    

---

## 4. Reglas de Oro del Repositorio

1. **Nunca subir archivos sin nombre claro**
    
2. **Nunca sobrescribir sin avisar**
    
3. **Todo cambio importante va al changelog**
    
4. **El contenido vive en `/content`, no en el código**
    
5. **El código no explica el proyecto, el contenido sí**
    

---

## 5. Por qué esta estructura funciona para FLL

- Permite actualizaciones rápidas en torneo
    
- Evita errores de último minuto
    
- Facilita trabajo en paralelo
    
- Es reutilizable para temporadas futuras
    

---

_Esta estructura es obligatoria para el desarrollo de la plataforma digital CALIBOTS KAIROS. Cualquier nueva funcionalidad debe adaptarse a este esquema._