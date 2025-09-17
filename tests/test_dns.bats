#!/usr/bin/env bats

@test_dns "dig devuelve una respuesta no vacía" {
  run dig example.com
  [ "$status" -eq 0 ]
  [ -n "$output" ]
}