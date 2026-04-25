

## Aplicar nueva paleta de colores

Nueva paleta con 6 colores que introduce tonos mas frescos incluyendo un azul cielo y verdes salvia.

### Mapeo de colores

| Hex | HSL | Uso en el sitio |
|-----|-----|-----------------|
| `#D6CDA4` | `49 38% 74%` | **Background** - Fondo general (khaki claro) |
| `#8B5B29` | `31 54% 35%` | **Foreground / Dark-brown** - Texto principal, Hero, Footer (marron terroso) |
| `#D6A340` | `40 64% 55%` | **Primary** - Botones principales, color de marca (dorado) |
| `#49784C` | `124 24% 38%` | **Secondary** - Badges, botones secundarios (verde bosque) |
| `#A4C8E1` | `205 46% 76%` | **Accent** - Elementos de enfasis, highlights (azul cielo) |
| `#A8BBA1` | `104 14% 68%` | **Muted** - Fondos suaves, elementos pasivos (verde salvia) |

### Cambios por archivo

**`src/index.css`** - Actualizar todas las variables CSS:

- `--background`: `49 38% 74%` (khaki `#D6CDA4`)
- `--foreground`: `31 54% 22%` (version mas oscura del marron para legibilidad del texto)
- `--card`: `49 38% 84%` (khaki mas claro para que las cards resalten)
- `--card-foreground`: `31 54% 22%`
- `--primary`: `40 64% 55%` (dorado `#D6A340`)
- `--primary-foreground`: `0 0% 100%`
- `--secondary`: `124 24% 38%` (verde bosque `#49784C`)
- `--secondary-foreground`: `0 0% 100%`
- `--muted`: `104 14% 68%` (verde salvia `#A8BBA1`)
- `--muted-foreground`: `31 54% 35%` (marron `#8B5B29`)
- `--accent`: `205 46% 76%` (azul cielo `#A4C8E1`)
- `--accent-foreground`: `31 54% 22%` (texto oscuro sobre azul claro)
- `--border`: `49 25% 65%`
- `--ring`: `40 64% 55%`
- `--sand`: `49 38% 74%`
- `--teal`: `124 24% 38%`
- `--mustard`: `40 64% 55%`
- `--crimson`: `31 54% 35%`
- `--dark-brown`: `31 54% 35%`

**`src/pages/Index.tsx`** - Hero con fondo marron terroso:
- Fondo: `bg-dark-brown` (usando `#8B5B29`)

**`src/components/Footer.tsx`** - Mismo fondo oscuro:
- Fondo: `bg-dark-brown`

**`src/pages/QuienesSomos.tsx`** - Secciones oscuras:
- Fondo: `bg-dark-brown`

### Resultado

- Paleta mas fresca y variada con la introduccion del azul cielo como acento
- El verde bosque se mantiene como secondary para badges y botones
- El dorado como primary da presencia a los CTAs
- El verde salvia como muted aporta suavidad a fondos pasivos
- Fondo khaki calido que armoniza todos los colores
