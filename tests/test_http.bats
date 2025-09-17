#!/usr/bin/env bats

setup() { rm -rf out; }

@test "HTTP: script genera archivo con encabezado" {
  TARGET=github.com ./src/http_check.sh
  [ -f "out/http_check.txt" ]
  grep "HTTP CHECK (github.com)" out/http_check.txt
  grep -E "^HTTP/" out/http_check.txt
}

@test "HTTP: devuelve código 200 para example.com" {
  TARGET=example.com ./src/http_check.sh
  run grep -E "^HTTP/.* 200\b" out/http_check.txt
  [ "$status" -eq 0 ]
}

@test "Robustez: falla con dominio inválido y limpia artefactos" {
  run env TARGET=dominio.que-no-existe.invalid ./src/http_check.sh
  [ "$status" -ne 0 ]
  [ ! -f "out/http_check.txt" ]
}
