# NOTA (29/Enero/2026)
## 📘 DOCUMENTO DE ESPECIFICACIONES

## Plataforma Digital CALIBOTS KAIROS

**FIRST LEGO League Challenge – UNEARTHED 2025–2026**

---

## 0. VISIÓN ESTRATÉGICA GENERAL

**Objetivo macro:**  
Construir una **plataforma digital centralizada, interactiva y profesional** que:

1. **Ahorre tiempo crítico** en las salas de jueces.
    
2. Evidencie **cumplimiento claro de rúbricas FLL**.
    
3. Impresione a **públicos externos** (patrocinadores, medios, comunidad).
    
4. Funcione como **archivo histórico y legado digital** del equipo.
    

**Concepto clave:**

> _“Lo que no se entiende en 30 segundos, no cuenta en FLL.”_

Esta plataforma está diseñada para que **un juez pueda comprender al equipo en menos de 2 minutos**, y luego profundizar solo si lo desea.

---

## 1. ARQUITECTURA DE INFORMACIÓN (INFORMATION ARCHITECTURE)

### 🧭 Estructura General

Formato: **SPA (Single Page Application)** con scroll suave + menú fijo.

```
/
├── Home / Quiénes Somos
│   ├── Hero (video/GIF)
│   ├── Identidad + lema UNEARTHED
│   ├── Equipo (cards interactivas)
│   ├── Timeline 4 años
│   ├── Coaches & Mentores
│   └── Core Values (con evidencias)
│
├── Proyecto de Innovación
│   ├── Portada del proyecto
│   ├── Investigación & Necesidad
│   ├── Solución Propuesta
│   │   └── Visor 3D interactivo
│   ├── Iteración & Desarrollo
│   ├── Tecnologías
│   └── Impacto
│
├── Diseño del Robot
│   ├── Filosofía de diseño
│   ├── Robot base (3D)
│   ├── Attachments
│   │   └── (1 página/modal por attachment)
│   └── Plan de Misiones (tabla dinámica)
│
├── Galería Multimedia
│   ├── Filtros por categoría
│   └── Fotos + videos cortos
│
├── (Opcional) Kairos Play
│   └── Minijuego educativo
│
└── Área Interna (privada)
    └── Bitácora / Changelog
```

---

### 📌 Tipos de Contenido por Sección

|Sección|Texto|Imagen|Video|3D|Interactivo|
|---|---|---|---|---|---|
|Home|✔|✔|✔|–|✔|
|Innovación|✔|✔|✔|✔|✔|
|Robot|✔|✔|✔|✔|✔|
|Galería|–|✔|✔|–|✔|
|Juego|✔|✔|✔|–|✔|
|Bitácora|✔|–|–|–|✔|

---

## 2. GUÍA DE ESTILO VISUAL (IDENTIDAD)

### 🎨 Paleta de Colores (UNEARTED + Tecnología)

**Primarios**

- Verde profundo tierra: `#1F3D2B`
    
- Azul tecnológico oscuro: `#0B1C2D`
    

**Secundarios**

- Verde energía: `#3FB984`
    
- Naranja mineral/acento: `#F29F05`
    

**Neutrales**

- Blanco limpio: `#FFFFFF`
    
- Gris claro: `#E6E8EB`
    
- Gris texto: `#5F6368`
    

👉 Contraste alto para lectura rápida por jueces.

---

### 🔤 Tipografías (Google Fonts)

- **Títulos:** `Space Grotesk`  
    Moderna, técnica, muy usada en tecnología y robótica.
    
- **Texto y UI:** `Inter`  
    Excelente legibilidad en móviles y pantallas pequeñas.
    
- **Datos técnicos / tablas:** `JetBrains Mono` (opcional)
    

---

### ✍️ Tono de Escritura

- **Claro, directo, técnico ligero**
    
- Frases cortas
    
- Cero relleno
    
- Siempre responder:
    
    - ¿Qué problema?
        
    - ¿Qué hicimos?
        
    - ¿Por qué importa?
        

Ejemplo correcto:

> “Detectamos un problema real en ___ mediante entrevistas con ___. Diseñamos una solución que ___ y puede aplicarse en ___.”

---

## 3. STACK TECNOLÓGICO RECOMENDADO

### 🏗️ Opción Recomendada (Equilibrio total)

**Frontend**

- **Next.js (React)**
    
- Deploy en **Vercel**
    
- SPA + scroll sections
    

**Contenido**

- **Markdown + Decap CMS**
    
- Edición sin tocar código
    
- Ideal para estudiantes
    

**3D**

- **Sketchfab (embebido)**
    
    - Compatible con móviles
        
    - Rotación, zoom, annotations
        

**Multimedia**

- Videos comprimidos (`.mp4`, <8MB)
    
- GIFs optimizados (`.webp`)
    

**Offline / Evento**

- **PWA básica**
    
- Cache de páginas clave
    
- Modo “lite”
    

---

### 🧠 Alternativa Low-Code

Si NO hay programador dedicado:

- **Webflow** + embeds Sketchfab
    
- Más rápido, menos técnico
    
- Menos control offline
    

---

## 4. PLAN DE IMPLEMENTACIÓN POR FASES

### 🚀 FASE 1 – MVP (OBLIGATORIO – Primera competencia)

⏱️ 2–3 semanas

- Home completa
    
- Proyecto Innovación (sin iteración avanzada)
    
- Robot (1–2 attachments clave)
    
- Galería básica
    
- QR funcional
    
- Folleto jueces
    

---

### ⚙️ FASE 2 – Optimización (Regional / Nacional)

⏱️ 2 semanas

- Iteración detallada
    
- Todos los attachments
    
- Tabla misiones dinámica
    
- Más videos cortos
    
- Core Values con evidencias claras
    

---

### 🌱 FASE 3 – Legado

⏱️ Post-temporada

- Kairos Play
    
- Línea histórica completa
    
- Archivo descargable
    
- Versión “Museo del equipo”
    

---

## 5. CHECKLIST MAESTRO DE CONTENIDOS

### 📸 Multimedia

-  Fotos equipo (horizontal y vertical)
    
-  Video hero (15–30s)
    
-  Videos de cada attachment (<10s)
    
-  Clips de Core Values
    
-  Fotos proceso (taller, errores, pruebas)
    

---

### 🧠 Textos

-  Elevator pitch del equipo
    
-  Roles de cada integrante
    
-  Historia del proyecto
    
-  Problema validado
    
-  Impacto esperado
    
-  Filosofía del robot
    
-  Estrategia de misiones
    

---

### 🧩 Técnicos

-  Modelos 3D (robot + attachments)
    
-  Exportes Studio 2.0
    
-  Logos y branding
    
-  Tabla de misiones
    

---

### 📄 Impreso

-  Dossier jueces (1–2 caras)
    
-  QRs verificados
    
-  Mini tarjetas de integrantes (opcional)
    

---

## 6. SECCIÓN 5 – KAIROS PLAY (RECOMENDACIÓN)

### ✅ Pros

- Diferenciación total
    
- Impacto educativo real
    
- Alineación con Core Values
    
- Recordación del equipo
    

### ⚠️ Contras

- Consume tiempo
    
- No suma puntos directos si está mal hecho
    

---

### 🎮 Idea Viable (2–3 semanas)

**Nombre:** _“Excava con KAIROS”_

**Concepto:**  
Mini juego web donde el usuario:

1. Identifica un problema
    
2. Elige herramientas
    
3. Ensambla una solución simple
    
4. Aprende el concepto clave del proyecto
    

**Tecnología**

- HTML + JS
    
- Funciona en móvil
    
- Sin descarga
    
- Ligero
    

👉 Recomendado **solo si el MVP está sólido**.

---

## CIERRE ESTRATÉGICO

Esta plataforma no es un lujo.  
Es una **herramienta competitiva**, un **acelerador de evaluación** y un **archivo de impacto**.

Si CALIBOTS KAIROS ejecuta esto bien, **no solo se verá como un equipo fuerte**,  
se verá como un **equipo serio, maduro y de siguiente nivel**.


