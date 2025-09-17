## HTTP Check

El script http_check.sh genera archivos de salida que contienen información sobre la verificación HTTP de un target especificado.

### Archivos Generados: http_check.txt

#### http_check.txt

Generado por src/http_check.sh, se ubica en out/http_check.txt, contiene el resultado de la verificación HTTP HEAD del target especificado.

Ejecución de ejemplo del script:

```bash
TARGET=github.com ./src/http_check.sh
```

#### Formato de Salida - Estructura del archivo http_check.txt

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

#### Componentes del archivo http_check.txt:

- Línea de encabezado HTTP CHECK (TARGET_NAME)`
- Línea de estado HTTP (ej: `HTTP/1.1 200 OK` o `HTTP/1.1 301 Moved Permanently` )
- Headers HTTP del servidor de destino
- Información de conexión y metadatos

#### Validación Automatizada con bats

El archivo test_http.bats proporciona las siguientes validaciones:

- Confirma que el archivo de salida fue creado correctamente
- Verifica que el archivo contiene la línea de identificación con el target correcto
- Confirma que existe al menos una línea que comience con "HTTP/" (línea de estado HTTP)

Ejecución de pruebas:

```bash
bats tests/test_http.bats
```