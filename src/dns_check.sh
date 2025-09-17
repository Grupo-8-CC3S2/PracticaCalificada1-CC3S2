
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
 
parseo_grep
 


