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

## Sistema Básico de Monitoreo TLS

Archivos relacionados: `src/monitor_TLS`, `monitoreo-TLS.service`, `Makefile` y `env.conf`.

### Salida-Logs

#### `make install-monitor-tls`

Ejecución:

```
jquispe@pc1-quispe:~/Escritorio/cursos/Actividades/PracticaCalificada1-CC3S2$ make install-monitor-tls 
Instalando servicio en systemd...
Created symlink '/etc/systemd/system/multi-user.target.wants/monitoreo-TLS.service' → '/etc/systemd/system/monitoreo-TLS.service'.
Servicio instalado en /etc/systemd/system/monitoreo-TLS.service
```

Además se crea el archivo `monitoreo-TLS.service` en `/etc/systemd/system`:

```
jquispe@pc1-quispe:/etc/systemd/system$ cat monitoreo-TLS.service 
[Unit]
Description=Monitoreo básico de TLS
After=network.target

[Service]
Type=simple
EnvironmentFile=/home/jquispe/Escritorio/cursos/Actividades/PracticaCalificada1-CC3S2/env.conf
ExecStart=/bin/bash /home/jquispe/Escritorio/cursos/Actividades/PracticaCalificada1-CC3S2/src/monitor_TLS.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

#### `make start-monitor-tls` y `make stop-monitor-tls`

```
jquispe@pc1-quispe:~/Escritorio/cursos/Actividades/PracticaCalificada1-CC3S2$ make start-monitor-tls 
Servicio iniciado.
```

```
jquispe@pc1-quispe:~/Escritorio/cursos/Actividades/PracticaCalificada1-CC3S2$ make stop-monitor-tls 
Servicio detenido.
```

#### `make status-monitor-tls`

```
jquispe@pc1-quispe:~/Escritorio/cursos/Actividades/PracticaCalificada1-CC3S2$ make status-monitor-tls 
● monitoreo-TLS.service - Monitoreo básico de TLS
     Loaded: loaded (/etc/systemd/system/monitoreo-TLS.service; enabled; preset: enabled)
     Active: active (running) since Tue 2025-09-16 23:52:30 -05; 31s ago
 Invocation: 1c175738b82b4df7bef79e5104371b0d
   Main PID: 49885 (bash)
      Tasks: 2 (limit: 9246)
     Memory: 608K (peak: 3.5M)
        CPU: 204ms
     CGroup: /system.slice/monitoreo-TLS.service
             ├─49885 /bin/bash /home/jquispe/Escritorio/cursos/Actividades/PracticaCalificada1-CC3S2/s>
             └─49992 sleep 15

sep 16 23:53:01 pc1-quispe bash[49986]: Server public key is 256 bit
sep 16 23:53:01 pc1-quispe bash[49986]: This TLS version forbids renegotiation.
sep 16 23:53:01 pc1-quispe bash[49986]: Compression: NONE
.
.
.
.
.
```

#### `make logs-monitor-tls`

Podemos ver en consola las verificaciones cada 15 segundos. Un ejemplo de una iteración:

```
sep 16 23:31:40 pc1-quispe bash[48454]: Probando TLS con github.com:443
sep 16 23:31:40 pc1-quispe bash[48520]: Connecting to 140.82.114.4
sep 16 23:31:40 pc1-quispe bash[48520]: depth=2 C=US, ST=New Jersey, L=Jersey City, O=The USERTRUST Network, CN=USERTrust ECC Certification Authority
sep 16 23:31:40 pc1-quispe bash[48520]: verify return:1
sep 16 23:31:40 pc1-quispe bash[48520]: depth=1 C=GB, ST=Greater Manchester, L=Salford, O=Sectigo Limited, CN=Sectigo ECC Domain Validation Secure Server CA
sep 16 23:31:40 pc1-quispe bash[48520]: verify return:1
sep 16 23:31:40 pc1-quispe bash[48520]: depth=0 CN=github.com
sep 16 23:31:40 pc1-quispe bash[48520]: verify return:1
sep 16 23:31:40 pc1-quispe bash[48520]: CONNECTED(00000003)
sep 16 23:31:40 pc1-quispe bash[48520]: ---
sep 16 23:31:40 pc1-quispe bash[48520]: Certificate chain
sep 16 23:31:40 pc1-quispe bash[48520]:  0 s:CN=github.com
sep 16 23:31:40 pc1-quispe bash[48520]:    i:C=GB, ST=Greater Manchester, L=Salford, O=Sectigo Limited, CN=Sectigo ECC Domain Validation Secure Server CA
sep 16 23:31:40 pc1-quispe bash[48520]:    a:PKEY: EC, (prime256v1); sigalg: ecdsa-with-SHA256
sep 16 23:31:40 pc1-quispe bash[48520]:    v:NotBefore: Feb  5 00:00:00 2025 GMT; NotAfter: Feb  5 23:59:59 2026 GMT
sep 16 23:31:40 pc1-quispe bash[48520]:  1 s:C=GB, ST=Greater Manchester, L=Salford, O=Sectigo Limited, CN=Sectigo ECC Domain Validation Secure Server CA
sep 16 23:31:40 pc1-quispe bash[48520]:    i:C=US, ST=New Jersey, L=Jersey City, O=The USERTRUST Network, CN=USERTrust ECC Certification Authority
sep 16 23:31:40 pc1-quispe bash[48520]:    a:PKEY: EC, (prime256v1); sigalg: ecdsa-with-SHA384
sep 16 23:31:40 pc1-quispe bash[48520]:    v:NotBefore: Nov  2 00:00:00 2018 GMT; NotAfter: Dec 31 23:59:59 2030 GMT
sep 16 23:31:40 pc1-quispe bash[48520]:  2 s:C=US, ST=New Jersey, L=Jersey City, O=The USERTRUST Network, CN=USERTrust ECC Certification Authority
sep 16 23:31:40 pc1-quispe bash[48520]:    i:C=GB, ST=Greater Manchester, L=Salford, O=Comodo CA Limited, CN=AAA Certificate Services
sep 16 23:31:40 pc1-quispe bash[48520]:    a:PKEY: EC, (secp384r1); sigalg: sha384WithRSAEncryption
sep 16 23:31:40 pc1-quispe bash[48520]:    v:NotBefore: Mar 12 00:00:00 2019 GMT; NotAfter: Dec 31 23:59:59 2028 GMT
sep 16 23:31:40 pc1-quispe bash[48520]: ---
sep 16 23:31:40 pc1-quispe bash[48520]: Server certificate
sep 16 23:31:40 pc1-quispe bash[48520]: -----BEGIN CERTIFICATE-----
sep 16 23:31:40 pc1-quispe bash[48520]: MIIEoTCCBEigAwIBAgIRAKtmhrVie+gFloITMBKGSfUwCgYIKoZIzj0EAwIwgY8x
sep 16 23:31:40 pc1-quispe bash[48520]: CzAJBgNVBAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNV
sep 16 23:31:40 pc1-quispe bash[48520]: BAcTB1NhbGZvcmQxGDAWBgNVBAoTD1NlY3RpZ28gTGltaXRlZDE3MDUGA1UEAxMu
sep 16 23:31:40 pc1-quispe bash[48520]: U2VjdGlnbyBFQ0MgRG9tYWluIFZhbGlkYXRpb24gU2VjdXJlIFNlcnZlciBDQTAe
sep 16 23:31:40 pc1-quispe bash[48520]: Fw0yNTAyMDUwMDAwMDBaFw0yNjAyMDUyMzU5NTlaMBUxEzARBgNVBAMTCmdpdGh1
sep 16 23:31:40 pc1-quispe bash[48520]: Yi5jb20wWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAAQgNFxG/yzL+CSarvC7L3ep
sep 16 23:31:40 pc1-quispe bash[48520]: H5chNnG6wiYYxR5D/Z1J4MxGnIX8KbT5fCgLoyzHXL9v50bdBIq6y4AtN4gN7gbW
sep 16 23:31:40 pc1-quispe bash[48520]: o4IC/DCCAvgwHwYDVR0jBBgwFoAU9oUKOxGG4QR9DqoLLNLuzGR7e64wHQYDVR0O
sep 16 23:31:40 pc1-quispe bash[48520]: BBYEFFPIf96emE7HTda83quVPjA9PdHIMA4GA1UdDwEB/wQEAwIHgDAMBgNVHRMB
sep 16 23:31:40 pc1-quispe bash[48520]: Af8EAjAAMB0GA1UdJQQWMBQGCCsGAQUFBwMBBggrBgEFBQcDAjBJBgNVHSAEQjBA
sep 16 23:31:40 pc1-quispe bash[48520]: MDQGCysGAQQBsjEBAgIHMCUwIwYIKwYBBQUHAgEWF2h0dHBzOi8vc2VjdGlnby5j
sep 16 23:31:40 pc1-quispe bash[48520]: b20vQ1BTMAgGBmeBDAECATCBhAYIKwYBBQUHAQEEeDB2ME8GCCsGAQUFBzAChkNo
sep 16 23:31:40 pc1-quispe bash[48520]: dHRwOi8vY3J0LnNlY3RpZ28uY29tL1NlY3RpZ29FQ0NEb21haW5WYWxpZGF0aW9u
sep 16 23:31:40 pc1-quispe bash[48520]: U2VjdXJlU2VydmVyQ0EuY3J0MCMGCCsGAQUFBzABhhdodHRwOi8vb2NzcC5zZWN0
sep 16 23:31:40 pc1-quispe bash[48520]: aWdvLmNvbTCCAX4GCisGAQQB1nkCBAIEggFuBIIBagFoAHUAlpdkv1VYl633Q4do
sep 16 23:31:40 pc1-quispe bash[48520]: NwhCd+nwOtX2pPM2bkakPw/KqcYAAAGU02uUSwAABAMARjBEAiA7i6o+LpQjt6Ae
sep 16 23:31:40 pc1-quispe bash[48520]: EjltHhs/TiECnHd0xTeer/3vD1xgsAIgYlGwRot+SqEBCs//frx/YHTPwox9QLdy
sep 16 23:31:40 pc1-quispe bash[48520]: 7GjTLWHfcMAAdwAZhtTHKKpv/roDb3gqTQGRqs4tcjEPrs5dcEEtJUzH1AAAAZTT
sep 16 23:31:40 pc1-quispe bash[48520]: a5PtAAAEAwBIMEYCIQDlrInx7J+3MfqgxB2+Fvq3dMlk1qj4chOw/+HkYVfG0AIh
sep 16 23:31:40 pc1-quispe bash[48520]: AMT+JKAQfUuIdBGxfryrGrwsOD3pRs1tyAyykdPGRgsTAHYAyzj3FYl8hKFEX1vB
sep 16 23:31:40 pc1-quispe bash[48520]: 3fvJbvKaWc1HCmkFhbDLFMMUWOcAAAGU02uUJQAABAMARzBFAiEA1GKW92agDFNJ
sep 16 23:31:40 pc1-quispe bash[48520]: IYrMH3gaJdXsdIVpUcZOfxH1FksbuLECIFJCfslINhc53Q0TIMJHdcFOW2tgG4tB
sep 16 23:31:40 pc1-quispe bash[48520]: A1dL881tXbMnMCUGA1UdEQQeMByCCmdpdGh1Yi5jb22CDnd3dy5naXRodWIuY29t
sep 16 23:31:40 pc1-quispe bash[48520]: MAoGCCqGSM49BAMCA0cAMEQCIHGMp27BBBJ1356lCe2WYyzYIp/fAONQM3AkeE/f
sep 16 23:31:40 pc1-quispe bash[48520]: ym0sAiBtVfN3YgIZ+neHEfwcRhhz4uDpc8F+tKmtceWJSicMkA==
sep 16 23:31:40 pc1-quispe bash[48520]: -----END CERTIFICATE-----
sep 16 23:31:40 pc1-quispe bash[48520]: subject=CN=github.com
sep 16 23:31:40 pc1-quispe bash[48520]: issuer=C=GB, ST=Greater Manchester, L=Salford, O=Sectigo Limited, CN=Sectigo ECC Domain Validation Secure Server CA
sep 16 23:31:40 pc1-quispe bash[48520]: ---
sep 16 23:31:40 pc1-quispe bash[48520]: No client certificate CA names sent
sep 16 23:31:40 pc1-quispe bash[48520]: Peer signing digest: SHA256
sep 16 23:31:40 pc1-quispe bash[48520]: Peer signature type: ecdsa_secp256r1_sha256
sep 16 23:31:40 pc1-quispe bash[48520]: Peer Temp Key: X25519, 253 bits
sep 16 23:31:40 pc1-quispe bash[48520]: ---
sep 16 23:31:40 pc1-quispe bash[48520]: SSL handshake has read 3481 bytes and written 1616 bytes
sep 16 23:31:40 pc1-quispe bash[48520]: Verification: OK
sep 16 23:31:40 pc1-quispe bash[48520]: ---
sep 16 23:31:40 pc1-quispe bash[48520]: New, TLSv1.3, Cipher is TLS_AES_128_GCM_SHA256
sep 16 23:31:40 pc1-quispe bash[48520]: Protocol: TLSv1.3
sep 16 23:31:40 pc1-quispe bash[48520]: Server public key is 256 bit
sep 16 23:31:40 pc1-quispe bash[48520]: This TLS version forbids renegotiation.
sep 16 23:31:40 pc1-quispe bash[48520]: Compression: NONE
sep 16 23:31:40 pc1-quispe bash[48520]: Expansion: NONE
sep 16 23:31:40 pc1-quispe bash[48520]: No ALPN negotiated
sep 16 23:31:40 pc1-quispe bash[48520]: Early data was not sent
sep 16 23:31:40 pc1-quispe bash[48520]: Verify return code: 0 (ok)
sep 16 23:31:40 pc1-quispe bash[48520]: ---
sep 16 23:31:40 pc1-quispe bash[48520]: DONE
sep 16 23:31:40 pc1-quispe bash[48454]: TLS OK en github.com:443
```

#### `make delete-monitor-tls`

```
jquispe@pc1-quispe:~/Escritorio/cursos/Actividades/PracticaCalificada1-CC3S2$ make delete-monitor-tls 
Deteniendo y eliminando servicio...
Removed '/etc/systemd/system/multi-user.target.wants/monitoreo-TLS.service'.
Servicio eliminado.
```