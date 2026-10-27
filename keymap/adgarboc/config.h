#pragma once

// Use the generic 03h second-stage bootloader. The default W25Q080 boot2
// assumes the Pico's QSPI flash chip; clone ProMicro RP2040 boards ship
// other flash chips that fail to XIP with it (board re-enters BOOTSEL
// after flashing). 03h serial read works with virtually any chip.
#define RP2040_FLASH_GENERIC_03H

// Vial identity for this keymap. The UID and the two-key unlock combo are
// required by the Vial protocol; everything else inherits the crkbd defaults.
#define VIAL_KEYBOARD_UID {0x3B, 0x6B, 0xA0, 0x29, 0x80, 0x56, 0xED, 0xD1}
#define VIAL_UNLOCK_COMBO_ROWS {0, 0}
#define VIAL_UNLOCK_COMBO_COLS {0, 1}
