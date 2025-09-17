APP_DIR := $(shell pwd)
SERVICE := monitoreo-TLS.service
SERVICE_PATH := /etc/systemd/system/$(SERVICE)

.PHONY: install-monitor-tls start-monitor-tls stop-monitor-tls status-monitor-tls delete-monitor-tls logs-monitor-tls

install-monitor-tls:
	@echo "Instalando servicio en systemd..."
	@sed "s|{{APP_DIR}}|$(APP_DIR)|g" systemd/$(SERVICE) > $(SERVICE)
	@sudo mv $(SERVICE) $(SERVICE_PATH)
	@sudo systemctl daemon-reload
	@sudo systemctl enable $(SERVICE)
	@echo "Servicio instalado en $(SERVICE_PATH)"

start-monitor-tls:
	@sudo systemctl start $(SERVICE)
	@echo "Servicio iniciado."

stop-monitor-tls:
	@sudo systemctl stop $(SERVICE)
	@echo "Servicio detenido."

delete-monitor-tls:
	@echo "Deteniendo y eliminando servicio..."
	@sudo systemctl stop $(SERVICE)
	@sudo systemctl disable $(SERVICE)
	@sudo rm -f $(SERVICE_PATH)
	@sudo systemctl daemon-reload
	@echo "Servicio eliminado."

status-monitor-tls:
	@sudo systemctl status $(SERVICE)

logs-monitor-tls:
	@sudo journalctl -u $(SERVICE) -f
