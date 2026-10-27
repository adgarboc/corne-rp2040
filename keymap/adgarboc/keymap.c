/*
 * adgarboc keymap for the Corne (crkbd/rev1), M1 milestone.
 *
 * M1 is the "heartbeat" build: matrix + layers only. No OLED, no RGB, no
 * trackpad. Built for Pro Micro RP2040 drop-in boards via CONVERT_TO (see
 * rules.mk).
 *
 * Four layers, in matrix order: rows 0-3 are the left half, rows 4-7 the
 * right half (column 0 = outer edge).
 */
#include QMK_KEYBOARD_H

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
    // Layer 0: Dvorak (the home layer). Same physical positions as the QWERTY
    // layer below; only the emitted characters change. The OS layout must be
    // plain US QWERTY.
    //   row 0: ' , . p y     f g c r l
    //   row 1: a o e u i     d h t n s
    //   row 2: ; q j k x     b m w v z
    [0] = {
        {  KC_TAB,  KC_QUOT,  KC_COMM,   KC_DOT,     KC_P,     KC_Y},
        { KC_LSFT,     KC_A,     KC_O,     KC_E,     KC_U,     KC_I},
        { KC_LCTL,  KC_SCLN,     KC_Q,     KC_J,     KC_K,     KC_X},
        {   KC_NO,    KC_NO,    KC_NO,    TG(1),  KC_LGUI,   KC_SPC},
        { KC_BSPC,     KC_L,     KC_R,     KC_C,     KC_G,     KC_F},
        { KC_RSFT,     KC_S,     KC_N,     KC_T,     KC_H,     KC_D},
        {  KC_ESC,     KC_Z,     KC_V,     KC_W,     KC_M,     KC_B},
        {   KC_NO,    KC_NO,    KC_NO,    MO(3),    MO(2),   KC_ENT}
    },
    // Layer 1: QWERTY, for gaming. Entered and left with TG(1) on the outer
    // left thumb.
    [1] = {
        {  KC_TAB,     KC_Q,     KC_W,     KC_E,     KC_R,     KC_T},
        { KC_LSFT,     KC_A,     KC_S,     KC_D,     KC_F,     KC_G},
        { KC_LCTL,     KC_Z,     KC_X,     KC_C,     KC_V,     KC_B},
        {   KC_NO,    KC_NO,    KC_NO,    TG(1),  KC_LGUI,   KC_SPC},
        { KC_BSPC,     KC_P,     KC_O,     KC_I,     KC_U,     KC_Y},
        { KC_RSFT,  KC_SCLN,     KC_L,     KC_K,     KC_J,     KC_H},
        {  KC_ESC,   KC_SLSH,   KC_DOT, KC_COMMA,     KC_M,     KC_N},
        {   KC_NO,    KC_NO,    KC_NO,    MO(3),    MO(2),   KC_ENT}
    },
    // Layer 2: numbers, programming symbols, arrows and navigation. The outer
    // column and the borders stay TRNS so Ctrl and Esc are not lost while
    // typing code. Shifted symbols come out with Shift ({ } | + _ : " < > ? ~),
    // exactly like on a regular keyboard.
    [2] = {
        {   KC_GRV,     KC_1,     KC_2,     KC_3,     KC_4,     KC_5},
        {  KC_TRNS,  KC_MINS,   KC_EQL,  KC_LBRC,  KC_RBRC,  KC_BSLS},
        {  KC_TRNS,  KC_LEFT,  KC_DOWN,    KC_UP,  KC_RGHT,  KC_TRNS},
        {   KC_NO,    KC_NO,    KC_NO,  KC_TRNS,  KC_TRNS,  KC_TRNS},
        {  KC_TRNS,     KC_0,     KC_9,     KC_8,     KC_7,     KC_6},
        {  KC_TRNS,   KC_SLSH,   KC_DOT, KC_COMMA,  KC_QUOT,  KC_SCLN},
        {  KC_TRNS,   KC_DEL,  KC_PGDN,   KC_PGUP,   KC_END,  KC_HOME},
        {   KC_NO,    KC_NO,    KC_NO,  KC_TRNS,  KC_TRNS,  KC_TRNS}
    },
    // Layer 3: system and mouse. Multimedia on top, F1-F6 and F7-F12 on the
    // lower rows, mouse buttons/wheel/acceleration. RGB and preset-cycle
    // keycodes from the original keymap are intentionally KC_NO here: M1 has
    // no RGB (see rules.mk).
    [3] = {
        {  KC_MPRV,  KC_MPLY,  KC_MNXT,  KC_MUTE,  KC_VOLD,  KC_VOLU},
        {  QK_BOOT,    KC_NO,    KC_NO,    KC_NO,    KC_NO,  KC_PAUS},
        {    KC_F1,    KC_F2,    KC_F3,    KC_F4,    KC_F5,    KC_F6},
        {   KC_NO,    KC_NO,    KC_NO,  KC_TRNS,  KC_TRNS,  KC_TRNS},
        {  KC_TRNS,  MS_WHLD,  MS_WHLU,  MS_BTN3,  MS_BTN2,  MS_BTN1},
        {  KC_TRNS,  MS_WHLR,  MS_WHLL,  MS_ACL2,  MS_ACL1,  MS_ACL0},
        {   KC_F12,   KC_F11,   KC_F10,    KC_F9,    KC_F8,    KC_F7},
        {   KC_NO,    KC_NO,    KC_NO,  KC_TRNS,  KC_TRNS,  KC_TRNS}
    }
};

#ifndef AUTO_SHIFT_ENABLE
// Auto Shift is disabled to keep the firmware lean, but Vial's QMK Settings
// section still references this symbol; provide a no-op so the link succeeds.
void set_autoshift_timeout(uint16_t timeout) {}
#endif
