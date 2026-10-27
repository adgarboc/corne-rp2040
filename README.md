# corne-rp2040

Firmware for a **Corne Chocolate v2.1 (crkbd/rev1)** running on **"ProMicro
RP2040" drop-in boards** (SparkFun Pro Micro RP2040 pinout, 16 MB flash, UF2
bootloader) with **Vial** for live keymap editing.

The repo holds only the personal keymap and the build tooling — the QMK/Vial
source tree is cloned and pinned at build time, so the exact firmware can be
rebuilt byte-for-byte from a clean machine with nothing but Docker.

## Repo layout

```
corne-rp2040/
├── keymap/adgarboc/     # Source of truth: rules.mk, config.h, keymap.c, vial.json
├── build.sh             # Reproducible build via Docker
├── firmware/            # Committed build output (.uf2) — release evidence
├── build/               # Cloned vial-qmk tree (gitignored, disposable)
└── README.md
```

The keymap has 4 layers: **0 = Dvorak**, **1 = QWERTY** (toggle with `TG(1)` on
the outer left thumb, for gaming), **2 = numbers/programming symbols/arrows**,
**3 = system/mouse/F1-F12**. The M1 milestone is intentionally a "heartbeat"
build: matrix + layers only, no OLED, no RGB, no trackpad.

## Requirements

- [Docker](https://docs.docker.com/get-docker/) (Desktop on Windows/macOS)
- Git
- On Windows: run `build.sh` from Git Bash

## Building

```bash
bash build.sh
```

The script:

1. Clones [vial-qmk](https://github.com/vial-kb/vial-qmk) into `build/` and
   checks out a **pinned commit**
   (`VIAL_QMK_COMMIT=dd43959ae5c08d8a28d38a1acf7b04e86b14a344`, master HEAD as
   of 2026-10-26) plus the submodules needed for an ARM/ChibiOS build.
2. Copies `keymap/adgarboc/` into the tree as
   `keyboards/crkbd/keymaps/adgarboc/`.
3. Runs `qmk compile -kb crkbd/rev1 -km adgarboc` inside
   `qmkfm/qmk_cli:1.2.0` (a fixed image tag — never a floating one).
4. Copies the result to `firmware/crkbd_rev1_adgarboc.uf2`.

`CONVERT_TO=sparkfun_pm2040` in `keymap/adgarboc/rules.mk` is what switches
the build from AVR to RP2040 and produces a `.uf2`.

## Flashing

The same `.uf2` file goes on **both halves**:

1. Connect one half by USB.
2. Hold **BOOT**, tap **RESET** — a drive named **RPI-RP2** appears.
3. Drag `firmware/crkbd_rev1_adgarboc.uf2` onto that drive. The board
   reboots into the firmware.
4. Repeat for the other half.

## Reproducibility notes

Two pins make the build reproducible, and both live at the top of
`build.sh`:

- `VIAL_QMK_COMMIT` — the vial-qmk source commit.
- `QMK_DOCKER_IMAGE` — the fixed `qmkfm/qmk_cli` image tag.

To upgrade, bump one pin at a time, rebuild, and commit the new `.uf2` with a
message that says which pin moved. Never let either value float.

## Milestones

- **M1** (this firmware): matrix + layers on RP2040. OLED, RGB and trackpad
  support are deliberately stripped out and come back in later milestones.
