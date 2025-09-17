#!/usr/bin/env bash
set -e
set -u
set -o pipefail
umask 022

TARGET="${TARGET:-google.com}"
DNS_SERVER="${DNS_SERVER:-8.8.8.8}"
OUT_DIR="out"
mkdir -v -p "$OUT_DIR"

echo "DNS CHECK ($TARGET con $DNS_SERVER)" > "$OUT_DIR/dns_check.txt"
dig @"$DNS_SERVER" A "$TARGET" >> "$OUT_DIR/dns_check.txt" 2>&1

ARCHIVO="$OUT_DIR/dns_check.txt"

parseo_grep(){
    echo "parseando"
    if [ -f ${ARCHIVO} ]; then 
        grep -E '([0-9]{1,3}\.){3}([0-9]{1,3}){1}' ${ARCHIVO} > ${OUT_DIR}/parseo_grep.txt;fi
}
 
parseo_cut() {
    echo "parseo con cut"
    if [ -f "$OUT_DIR/parseo_grep.txt" ]; then
        sed -n '3,8p' "$OUT_DIR/parseo_grep.txt" | cut -d ' ' -f5 > "$OUT_DIR/parseo_cut.txt"
    fi
}
parseo_awk() {
    echo "parseando con awk"
    if [ -f "$ARCHIVO" ]; then
        awk '/\tA\t/ {print $5}' "$ARCHIVO" > "$OUT_DIR/parseo_awk.txt"
    fi
}
parseo_grep
parseo_cut
parseo_awk

