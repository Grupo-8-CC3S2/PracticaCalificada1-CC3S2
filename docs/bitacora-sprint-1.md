
## Bitácora Sprint-1: Makefile inicial con targets obligatorios

Estudiante: Sanchez Vega
## Comandos ejecutados
- `make help` → mostró la lista de targets.
- `make tools` → verificó herramientas, creó `out/tools.ok`.
- `make build` → creó `out/build.ok`.
- `make run`   → creó `out/run.log`.
- `make test`  → creó `out/test.tap` con 1 prueba "smoke sprint1".
- `make pack`  → generó `dist/pc1-proy5-v0.1.tar.gz`.
- `make clean` → eliminó `out/` y `dist/`.

## Salidas relevantes
- `out/tools.ok`: tools-ok-1757991953
- `out/build.ok`: build-1757993275
- `out/dns_check.txt`
- `out/http_check.txt`
- `out/test.tap`: 1..0


## Bitácora Sprint-1: Chequeo HTTP con script y pruebas Bats

Estudiante: Quispe Villena

### Ejemplo de uso del script /src/http_check.sh

```bash
TARGET=github.com ./src/http_check.sh
```

Se definio TARGET=github.com como dominio de prueba. El script http_check.sh ejecuta curl -I y guarda el resultado en out/http_check.txt

Salida out/http_check.txt

```
HTTP CHECK (github.com)
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed

  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
HTTP/1.1 301 Moved Permanently
Content-Length: 0
Location: https://github.com/
```

El script funciona correctamente: crea el archivo y registra cabeceras HTTP. Tenemos un codigo "301 Moved Permanently" el cual significa que Github no está en HTTP, ahora está permanentemente en HTTPS

### Pruebas con Bats

El test test_http.bats verifica tres condiciones:
- Que el archivo out/http_check.txt existe.
- Que contiene HTTP CHECK (github.com).
- Que incluye cabeceras HTTP válidas (líneas que empiezan con HTTP/
Ademas tambien crea out/http_check.txt ya que usa el script /src/http_check.sh.

Ejecucion de test:

```bash
bats tests/test_http.bats
```

Salida: 

```
test_http.bats
 ✓ script genera archivo de salida con encabezado HTTP

1 test, 0 failures
```

## Bitácora Sprint-1

Estudiante: Flores villar

### Actividad 1: 
Revisión detallada del interprete bash, comnados internos (sustitucion  expansion), flags,configuraciones para rastreo de errores 
Archivos: repaso.sh , comandos.md

### Actividad 2:
ejecucion del scripts de 
Archivos: dns_check.sh  test_dns.bats Makefile 

#### Ejecucion del script bash
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

#### Ejecucion del script bats
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




