#!/bin/sh
#
# Archivo: status.sh
#
# Descripción: Script que recopila y muestra métricas del sistema incluyendo CPU,
# memoria, disco, carga del sistema, uptime, usuarios conectados, tráfico de red,
# temperatura de CPU, versión del kernel, procesos en ejecución y los 5 procesos
# con mayor uso de CPU. Formatea la salida para su visualización en Telegram.
#
# Autor: migbertweb
#
# Fecha: 2024-12-19
#
# Repositorio: https://github.com/migbertweb/bot_info_server
#
# Licencia: MIT License
#
# Uso: Ejecutado por el bot de Telegram mediante el comando /status para mostrar
# el estado actual del sistema de forma remota.
#
# Nota: Este proyecto usa Licencia MIT. Se recomienda (no obliga) mantener 
# derivados como código libre, especialmente para fines educativos.
#

set -e # Detener el script si hay un error

# Obtener métricas del sistema
cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
mem_usage=$(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2}')
disk_usage=$(df -h / | awk 'NR==2{print $5}')
load_avg=$(uptime | awk -F 'load average:' '{print $2}' | awk '{print $1}')
uptime=$(uptime -p)
users_connected=$(who | wc -l)
network_rx=$(cat /sys/class/net/$(ip route show default | awk '/default/ {print $5}')/statistics/rx_bytes)
network_tx=$(cat /sys/class/net/$(ip route show default | awk '/default/ {print $5}')/statistics/tx_bytes)
network_rx_mb=$(echo "scale=2; $network_rx / 1024 / 1024" | bc)
network_tx_mb=$(echo "scale=2; $network_tx / 1024 / 1024" | bc)
cpu_temp=$(sensors | awk '/Package id 0:/ {print $4}' | sed 's/+//g')
processes=$(ps aux | wc -l)
kernel_version=$(uname -rn)
# Obtener los últimos 5 procesos con mayor uso de CPU
top_processes=$(ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6 | awk '{print $1, $2, $3, $4"%", $5"%"}')
# Crear mensaje
echo -e "🖥️ **Estado del Sistema**\n- CPU: $cpu_usage%\n- Memoria: $mem_usage\n- Versión del kernel: $kernel_version\n- Disco: $disk_usage\n- Carga del sistema: $load_avg\n- Uptime: $uptime\n- Usuarios conectados: $users_connected\n- Red: RX $network_rx_mb MB / TX $network_tx_mb MB\n- Temperatura CPU: $cpu_temp\n- Procesos en ejecució: $processes\n\n- $top_processes"
