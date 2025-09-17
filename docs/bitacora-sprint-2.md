## Bitácora Sprint-2: Sistema Básico de Monitoreo TLS

`Estudiante: Quispe Villena`

Se implemento un monitoreo básico de TLS para un host específico. Utiliza un script en Bash junto con un servicio de systemd para verificar constantemente la conectividad TLS hacia un obejtivo definido en un env.conf. Todo el proceso de creacion e inicio del servicio y revision de logs esta
definido tambien en el Makefile.

Al iniciar el servicio (start-monitor-tls), se ejecuta el script monitor_TLS.sh. El script lee el host objetivo desde env.conf y entonces se realiza una prueba TLS cada 15 segundos.

Para usar esta funcionalidad es necesario tener un archivo de variables de entorno `env.conf` con:

```
TARGET_TLS=
```

Para esta guia y `docs/contrato-salidas.md` se uso `TARGET_TLS="github.com:443"`.


#### Makefile: make install-monitor-tls

Tras ejecutar `make install-monitor-tls` se instala el servicio en nuestra computadora. Ejemplo:

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

#### Makefile: make start-monitor-tls

Con `make start-monitor-tls` iniciamos el servicio de monitoreo TLS en segundo plano y comienza el ciclo de pruebas TLS cada 15 segundos. Los resultados se registran en journalctl, con `make stop-monitor-tls` detenemos el servicio y con `make delete-monitor-tls` eliminamos el servicio de systemd.

#### State-Logs

Con `make logs-monitor-tls` revisamos los logs en tiempo real del servicio con journalctl y con `make state-monitor-tls` revisamos el estado systemd del servicio creado.
