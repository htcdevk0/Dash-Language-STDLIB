#!/usr/bin/env bash
set -euo pipefail

# =========================================
# DASH GLOBAL BUILD SCRIPT
# =========================================

MODE="${1:-static}"

log() {
    printf "[all] %s\n" "$*"
}

err() {
    printf "[error] %s\n" "$*" >&2
    exit 1
}

# -------- CHECK MODE --------
if [[ "$MODE" != "static" && "$MODE" != "dynamic" ]]; then
    err "usage: ./all.sh [static|dynamic]"
fi

# -------- BUILD C IMPL --------
log "Building c_impl ($MODE)"

mkdir -p build

if [[ "$MODE" == "dynamic" ]]; then
    dash C_IMPL/c_impl.ds -d --shared -o build/libcimpl.so
    mkdir -p "$HOME/.dash/lib"
    cp build/libcimpl.so "$HOME/.dash/lib/"
else
    dash C_IMPL/c_impl.ds -d -c -o build/libcimpl.o
    mkdir -p "$HOME/.dash/static"
    cp build/libcimpl.o "$HOME/.dash/static/"
fi

# -------- MODULES --------
MODULES=(io os str fs)

for mod in "${MODULES[@]}"; do
    log "Building $mod ($MODE)"

    pushd "$mod" >/dev/null

    if [[ "$MODE" == "dynamic" ]]; then
        ./dbuild.sh dynamic send
    else
        ./dbuild.sh static send
    fi

    popd >/dev/null
done

log "All modules built and installed successfully"