# adgarboc keymap for crkbd/rev1 (Corne Chocolate v2.1), M1 milestone.
# Target: Pro Micro RP2040 drop-in boards (SparkFun Pro Micro RP2040 pinout,
# 16 MB flash, UF2 bootloader).

# RP2040 converter: swaps the AVR toolchain for ARM/ChibiOS and remaps the Pro
# Micro pins, so the build produces a flashable .uf2 instead of a .hex.
CONVERT_TO = sparkfun_pm2040

# Vial: live keymap editing from the Vial app.
VIAL_ENABLE = yes
LTO_ENABLE  = yes

# M1 keeps the firmware to matrix + layers: no OLED, no RGB.
OLED_ENABLE       = no
RGBLIGHT_ENABLE   = no
RGB_MATRIX_ENABLE = no

# Layer 3 uses mouse keycodes (MS_BTN1, MS_WHLU, ...).
MOUSEKEY_ENABLE = yes

# Layer 3 uses multimedia keys (KC_MPLY, KC_VOLU, ...).
EXTRAKEY_ENABLE = yes

# Vial turns these on by default, but this keymap defines none of them and
# the generated introspection code then fails to link. Matches the upstream
# keymap this is derived from.
QMK_SETTINGS        = no
TAP_DANCE_ENABLE    = no
COMBO_ENABLE        = no
KEY_OVERRIDE_ENABLE = no
# With Vial's REPEAT_KEY=yes default, vial.c calls
# dynamic_keymap_get_alt_repeat_key() whose definition is not compiled at this
# commit (upstream guard mismatch) -> undefined reference at link time. This
# keymap does not use alternate repeat keys; disable the feature.
REPEAT_KEY_ENABLE   = no
