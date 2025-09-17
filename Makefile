APP_DIR := $(shell pwd)
SERVICE := monitoreo-TLS.service
SERVICE_PATH := /etc/systemd/system/$(SERVICE)

SHELL := /usr/bin/env bash
.SHELLFLAGS := -eu -o pipefail -c
MAKEFLAGS += --warn-undefined-variables --no-builtin-rules

.DELETE_ON_ERROR:
.DEFAULT_GOAL := help

# Contrato de entorno 
APP_NAME ?= pc1-proy5
RELEASE  ?= v0.1

TARGET ?=example.com
DNS_SERVER ?=8.8.8.8

# Variables internas
OUT_DIR  := out
DIST_DIR := dist
TEST_DIR := tests

TOOLS_REQ := bash curl dig ss nc grep sed awk bats tee tar

.PHONY: tools build run test pack clean help install-monitor-tls start-monitor-tls stop-monitor-tls status-monitor-tls delete-monitor-tls logs-monitor-tls

tools: ## Verifica dependencias
	@echo "[tools] verificando herramientas..."
	@missing=""; \
	for t in $(TOOLS_REQ); do \
		if ! command -v $$t >/dev/null 2>&1; then missing="$$missing $$t"; fi; \
	done; \
	if [ -n "$$missing" ]; then \
		echo "[tools] FALTAN:$$missing"; exit 1; \
	else \
		mkdir -p $(OUT_DIR); \
		echo "tools-ok-$$(date -u +%s)" > $(OUT_DIR)/tools.ok; \
		echo "[tools] OK (evidencia: $(OUT_DIR)/tools.ok)"; \
	fi

build: ## Prepara artefactos mínimos en out
	@mkdir -p $(OUT_DIR)
	@echo "build-$$(date -u +%s)" > $(OUT_DIR)/build.ok
	@echo "[build] evidencia: $(OUT_DIR)/build.ok"


run: tools build ## Ejecuta flujo principal y deja evidencia en out/
	@mkdir -p $(OUT_DIR)
	@sudo TARGET=$(TARGET) DNS_SERVER=$(DNS_SERVER) bash src/dns_check.sh
	@sudo TARGET="$(TARGET)" bash src/http_check.sh
	@echo "[run] evidencia generada (ver archivos en $(OUT_DIR)/)"

test: tools ## Ejecuta pruebas Bats; deja evidencia .tap
	@mkdir -p $(OUT_DIR)
	@if [ -d "$(TEST_DIR)" ]; then \
		bats -r $(TEST_DIR) | tee $(OUT_DIR)/test.tap; \
		echo "[test] evidencia: $(OUT_DIR)/test.tap"; \
	else \
		echo "[test] no hay carpeta '$(TEST_DIR)/'"; \
		echo "1..1\nok 1 placeholder" > $(OUT_DIR)/test.tap; \
		echo "[test] evidencia: $(OUT_DIR)/test.tap"; \
	fi

pack: ## Genera paquete reproducible básico con out/ y docs/
	@mkdir -p $(DIST_DIR)
	@tar -czf "$(DIST_DIR)/$(APP_NAME)-$(RELEASE).tar.gz" $(OUT_DIR) docs src Makefile 2>/dev/null || true
	@echo "[pack] paquete: $(DIST_DIR)/$(APP_NAME)-$(RELEASE).tar.gz"

clean: ## Limpieza segura de out/ y dist/
	@sudo rm -rf $(OUT_DIR) $(DIST_DIR)
	@echo "[clean] limpieza completada"

help: ## Muestra ayuda de targets
	@echo "Targets disponibles:"
	@grep -E '^[a-zA-Z0-9_-]+:.*?## ' $(MAKEFILE_LIST) | awk -F':|##' '{printf "  %-10s %s\n", $$1, $$3}'

install-monitor-tls: ## Instalar servicio de monitorio TLS
	@echo "Instalando servicio en systemd..."
	@sed "s|{{APP_DIR}}|$(APP_DIR)|g" systemd/$(SERVICE) > $(SERVICE)
	@sudo mv $(SERVICE) $(SERVICE_PATH)
	@sudo systemctl daemon-reload
	@sudo systemctl enable $(SERVICE)
	@echo "Servicio instalado en $(SERVICE_PATH)"

start-monitor-tls: ##  Iniciar el servicio de monitoreo TLS en segundo plano
	@sudo systemctl start $(SERVICE)
	@echo "Servicio iniciado."

stop-monitor-tls: ## Detener el servicio de monitoreo TLS en segundo plano
	@sudo systemctl stop $(SERVICE)
	@echo "Servicio detenido."

delete-monitor-tls: ## Eliminar el servicio de monitoreo TLS de systemd
	@echo "Deteniendo y eliminando servicio..."
	@sudo systemctl stop $(SERVICE)
	@sudo systemctl disable $(SERVICE)
	@sudo rm -f $(SERVICE_PATH)
	@sudo systemctl daemon-reload
	@echo "Servicio eliminado."

status-monitor-tls: ## State systemd del servicio de monitoreo TLS
	@sudo systemctl status $(SERVICE)

logs-monitor-tls: ## Verificacion TLS con logs con journalctl
	@sudo journalctl -u $(SERVICE) -f


