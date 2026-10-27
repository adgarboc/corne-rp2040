#!/usr/bin/env bash
# Reproducible build of the crkbd/rev1 "adgarboc" keymap inside Docker.
#
# Produces firmware/crkbd_rev1_adgarboc.uf2 (the same file is flashed to both
# halves). Requires Docker; nothing else is needed on the host.
set -euo pipefail

# ---------------------------------------------------------------------------
# Pinned inputs. Bump these deliberately (one change per commit), never float.
# ---------------------------------------------------------------------------
# vial-qmk master HEAD as of 2026-10-26.
VIAL_QMK_COMMIT=dd43959ae5c08d8a28d38a1acf7b04e86b14a344
VIAL_QMK_URL=https://github.com/vial-kb/vial-qmk.git
# Fixed image tag (1.2.0 == "latest" as of 2026-10; a floating tag would not
# be reproducible).
QMK_DOCKER_IMAGE=qmkfm/qmk_cli:1.2.0
# Submodules required to compile crkbd/rev1 -> RP2040 (ARM/ChibiOS).
# lib/lufa and lib/printf are only needed for AVR builds but are cheap.
VIAL_QMK_SUBMODULES="lib/chibios lib/chibios-contrib lib/pico-sdk lib/lufa lib/printf"

KEYMAP_NAME=adgarboc
KEYBOARD=crkbd/rev1

ROOT="$(cd "$(dirname "$0")" && pwd)"
VQ="$ROOT/build/vial-qmk"

# Docker Desktop on Windows wants a Windows-style bind-mount path. cygpath -m
# converts the Git-Bash form (/d/...) to C:/...; on Linux/macOS it is absent
# and the POSIX path is used as-is.
if command -v cygpath >/dev/null 2>&1; then
    MOUNT_ROOT="$(cygpath -m "$ROOT")"
else
    MOUNT_ROOT="$ROOT"
fi

# Use the Docker Desktop Linux engine if the default context points at a
# unix socket that does not exist (happens when running from Git Bash).
if ! docker info >/dev/null 2>&1 && docker context inspect desktop-linux >/dev/null 2>&1; then
    export DOCKER_HOST="$(docker context inspect --format '{{.Endpoints.docker.Host}}' desktop-linux)"
fi

# 1. Clone vial-qmk and check out the pinned commit (skipped if already there).
if [ ! -d "$VQ" ]; then
    git clone --filter=blob:none --no-checkout "$VIAL_QMK_URL" "$VQ"
fi
git -C "$VQ" checkout --detach "$VIAL_QMK_COMMIT"

# 2. Submodules (shallow).
git -C "$VQ" submodule update --init --depth 1 $VIAL_QMK_SUBMODULES

# 2b. Guard: QMK's VIA block force-enables bootmagic (common_features.mk),
#     which on a bare unsoldered board reads its floating matrix as a held
#     key and jumps straight back to the bootloader after flashing. We keep
#     bootmagic off; bootloader entry uses the physical BOOT/RESET buttons.
sed -i 's|^    BOOTMAGIC_ENABLE := yes|    # BOOTMAGIC_ENABLE := yes # adgarboc: disabled (floating matrix on bare boards)|' \
    "$VQ/builddefs/common_features.mk"

# 3. Copy the keymap in. keymap/adgarboc/ is the source of truth; the tree
#    under build/ is disposable.
rm -rf "$VQ/keyboards/$KEYBOARD/keymaps/$KEYMAP_NAME"
mkdir -p "$VQ/keyboards/$KEYBOARD/keymaps/$KEYMAP_NAME"
cp -r "$ROOT/keymap/$KEYMAP_NAME/." "$VQ/keyboards/$KEYBOARD/keymaps/$KEYMAP_NAME/"

# 4. Compile inside Docker. MSYS_NO_PATHCONV / MSYS2_ARG_CONV_EXCL stop Git
#    Bash from rewriting container-side paths like /qmk.
mkdir -p "$ROOT/firmware"
MSYS_NO_PATHCONV=1 MSYS2_ARG_CONV_EXCL='*' docker run --rm \
    -v "${MOUNT_ROOT}/build/vial-qmk:/qmk" \
    -w /qmk \
    -e GIT_CONFIG_COUNT=1 \
    -e GIT_CONFIG_KEY_0=safe.directory \
    -e GIT_CONFIG_VALUE_0='*' \
    "$QMK_DOCKER_IMAGE" \
    qmk compile -kb "$KEYBOARD" -km "$KEYMAP_NAME" 2>&1 | tee "$ROOT/build/build.log"

# 5. Collect the .uf2 and print the tail of the build log (size report).
UF2_SRC="$(find "$VQ/.build" -maxdepth 1 -name '*.uf2' | head -n1)"
if [ -z "$UF2_SRC" ]; then
    echo "ERROR: build finished but no .uf2 was produced" >&2
    exit 1
fi
cp "$UF2_SRC" "$ROOT/firmware/crkbd_rev1_${KEYMAP_NAME}.uf2"

echo
echo "== build log (tail) =="
tail -n 12 "$ROOT/build/build.log"
echo "== firmware =="
ls -l "$ROOT/firmware/crkbd_rev1_${KEYMAP_NAME}.uf2"
