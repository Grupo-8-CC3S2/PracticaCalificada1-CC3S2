## Chequeo HTTP con script y pruebas Bats

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