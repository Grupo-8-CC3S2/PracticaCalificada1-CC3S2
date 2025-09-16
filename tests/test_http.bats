#!/usr/bin/env bats

setup() {
  rm -rf out
}

@test "script genera archivo de salida con encabezado HTTP" {
  TARGET=github.com ./src/http_check.sh

  # verificamos que el archivo se creó
  [ -f "out/http_check.txt" ]

  # verificamos que contiene el nombre del target
  grep "HTTP CHECK (github.com)" out/http_check.txt

  # verificamos que contiene una línea que empiece con HTTP/
  grep -E "^HTTP/" out/http_check.txt
}
