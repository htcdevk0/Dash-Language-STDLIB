#!/usr/bin/env bash
set -euo pipefail

# =========================================
# DASH BUILD SCRIPT (STATIC + DYNAMIC IO)
# =========================================

# -------- CONFIG --------
readonly BIN="${BIN:-dash}"
readonly FILE="${FILE:-io.ds}"

MODE="${1:-static}"
SEND="${2:-}"

# -------- OUTPUT --------
if [[ "$MODE" == "dynamic" ]]; then
    readonly OUTPUT="${OUTPUT:-../build/libdstdio.so}"
    readonly FLAGS=(-d --shared -o)
else
    readonly OUTPUT="${OUTPUT:-../build/libdstdio.o}"
    readonly FLAGS=(-d -c -o)
fi

# -------- UTILS --------
log() {
    printf "[build] %s\n" "$*"
}

err() {
    printf "[error] %s\n" "$*" >&2
    exit 1
}

# -------- CHECKS --------
command -v "$BIN" >/dev/null 2>&1 || err "compiler '$BIN' not found in PATH"
[[ -f "$FILE" ]] || err "input file '$FILE' not found"

outdir="$(dirname "$OUTPUT")"
mkdir -p "$outdir"

# -------- BUILD --------
cmd=("$BIN" "$FILE" "${FLAGS[@]}" "$OUTPUT")

log "Mode: $MODE"
log "Command: ${cmd[*]}"
log "Building '$FILE' -> '$OUTPUT'"

start_time=$(date +%s%N)

"${cmd[@]}"

end_time=$(date +%s%N)
elapsed_ms=$(( (end_time - start_time) / 1000000 ))

# -------- DONE --------
if [[ -f "$OUTPUT" ]]; then
    size=$(stat -c%s "$OUTPUT" 2>/dev/null || stat -f%z "$OUTPUT")
    log "Done in ${elapsed_ms}ms | Size: ${size} bytes"
else
    err "build finished but output not found"
fi

# -------- SEND --------
if [[ "$SEND" == "send" ]]; then
    if [[ "$MODE" == "dynamic" ]]; then
        target_dir="$HOME/.dash/lib"
    else
        target_dir="$HOME/.dash/static"
    fi

    log "Sending '$OUTPUT' -> '$target_dir'"

    mkdir -p "$target_dir"
    cp "$OUTPUT" "$target_dir/" || err "failed to copy file"

    log "Sent successfully"
fi