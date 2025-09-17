#!/usr/bin/env bash

RUNNING=true

fin() {
    echo "Cerrando monitor TLS..."
    RUNNING=false
}

trap fin SIGTERM

test_tls() {
    local hostport=$1
    local host="${hostport%:*}"
    echo "Probando TLS con $hostport"
    timeout 5 openssl s_client -connect "$hostport" -servername "$host" </dev/null
    if [ $? -eq 0 ]; then
        echo "TLS OK en $hostport"
    else
        echo "Fallo TLS en $hostport"
    fi
}

echo "Iniciando monitoreo TLS"

while $RUNNING; do
    test_tls "$TARGET_TLS"
    sleep 15
done

echo "Proceso finalizado."
