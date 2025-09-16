#!/usr/bin/env bash
set -euo pipefail

TARGET="${TARGET}"
OUT_DIR="out"
mkdir -p "$OUT_DIR"

echo "HTTP CHECK ($TARGET)" > "$OUT_DIR/http_check.txt"
curl -I "http://$TARGET" >> "$OUT_DIR/http_check.txt" 2>&1

echo "HTTP check guardado en $OUT_DIR/http_check.txt"