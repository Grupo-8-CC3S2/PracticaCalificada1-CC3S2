#!/usr/bin/env bats

setup() { rm -rf out; }

@test "DNS: dig devuelve respuesta no vacía" {
  run dig example.com
  [ "$status" -eq 0 ]
  [ -n "$output" ]
}

@test "DNS: existe registro A válido para example.com" {
  env TARGET=example.com DNS_SERVER=8.8.8.8 ./src/dns_check.sh

  [ -f "out/dns_check.txt" ]
  [ -f "out/parseo_awk.txt" ]

  run grep -E '^[0-9]{1,3}(\.[0-9]{1,3}){3}$' out/parseo_awk.txt
  [ "$status" -eq 0 ]

  run grep -E "\tA\t" out/dns_check.txt
  [ "$status" -eq 0 ]
}

@test "Robustez: falla con servidor DNS inválido" {
  run env TARGET=example.com DNS_SERVER=203.0.113.1 ./src/dns_check.sh
  [ "$status" -ne 0 ]
}
