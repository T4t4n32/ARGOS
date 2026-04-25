# software/ (ARGOS Raspberry Pi 5)

This folder contains the Raspberry Pi application (Python) for ARGOS V1.

## Recommended OS stack
- Raspberry Pi OS (Bookworm or newer)
- Camera stack: libcamera / rpicam + Picamera2 (for CSI cameras) when applicable.
  (Raspberry Pi documentation explains the modern stack.)  

## Setup (Pi)
1. Create a virtual environment:
   - `python3 -m venv .venv`
   - `source .venv/bin/activate`
2. Install dependencies:
   - `pip install -r requirements.txt`
3. Copy config:
   - `cp config/argos.example.yaml config/argos.yaml`
4. Run in dev mode:
   - `python -m argos_app --mode simulated`

## Where to place your current code
If you currently have a single-file prototype, put it in:
- `software/legacy/current_prototype.py`
and then migrate functions into `src/argos_app/` gradually.

## Notes
- Store runtime logs in `../data/` (gitignored).
- Keep hardware pin mappings in `config/argos.yaml`.
