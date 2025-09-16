# Bitácora calificada-1
## Actividad: 
Revisión detallada del interprete bash, comnados internos (sustitucion  expansion), flags,configuraciones para rastreo de errores 
Archivos: repaso.sh , comandos.md

## Actividad:
ejecucion del scripts de 
Archivos: dns_check.sh  test_dns.bats Makefile 

### Ejecucion del script bash
``sudo TARGET=example.com DNS_SERVER=8.8.8.8 bash src/dns_server.sh``

el dominio de prueba es example.com , el servidor autoritativo es 8.8.8.8 uno de los que gestiona google
el output se redirige a dns_check.txt  segun las lineas ``dig @"$DNS_SERVER" A "$TARGET" >> "OUT_DIR/dns_check.txt"`` 

```bash
;; ANSWER SECTION:
example.com.		8	IN	A	23.220.75.245
example.com.		8	IN	A	23.215.0.138
example.com.		8	IN	A	23.215.0.136
example.com.		8	IN	A	23.192.228.80
example.com.		8	IN	A	23.192.228.84
example.com.		8	IN	A	23.220.75.232
```
el cuerpo de la respuesta indica que se dispone de varios ip's para example.com

### Ejecucion del script bats
la ejecucion se realiza mediante
``bats src/test_dns.bats``
```bash
y produce la siguiente salida:
/test_dns.bats
test_dns.bats
✓ dig devuelve una respuesta no vacía

1 test, 0 failures

```

- Todas las tareas fueron probadas en Ubuntu 24.04.
- Se usó Git para control de versiones.
- Se creó `` para los últimos cambios y organización d
