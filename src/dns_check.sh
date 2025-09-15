#!/usr/bin/env bash
set -e
set -u
set -o pipefail
umask 022

TARGET="${TARGET}"
DNS_SERVER="${DNS_SERVER}"
OUT_DIR="out"
mkdir -v -p "$OUT_DIR"

echo "DNS CHECK ($TARGET con $DNS_SERVER)" > "$OUT_DIR/dns_check.txt"
dig @"$DNS_SERVER" A "$TARGET" >> "$OUT_DIR/dns_check.txt" 2>&1