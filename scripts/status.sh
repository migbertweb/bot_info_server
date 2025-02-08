#!/bin/sh
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
kernel_version=$(uname -r)
# Obtener los últimos 5 procesos con mayor uso de CPU
top_processes=$(ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6 | awk '{print $1, $2, $3, $4"%", $5"%"}')
# Crear mensaje
echo -e "🖥️ **Estado del Sistema**\n- CPU: $cpu_usage%\n- Memoria: $mem_usage\n- Versión del kernel: $kernel_version\n- Disco: $disk_usage\n- Carga del sistema: $load_avg\n- Uptime: $uptime\n- Usuarios conectados: $users_connected\n- Red: RX $network_rx_mb MB / TX $network_tx_mb MB\n- Temperatura CPU: $cpu_temp\n- Procesos en ejecución: $processes\n- $top_processes"

##!/bin/sh
#set -e  # Detener el script si hay un error
#
## Obtener métricas del sistema
#cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
#mem_usage=$(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2}')
#disk_usage=$(df -h / | awk 'NR==2{print $5}')
#
## Crear mensaje
#echo -e "🖥️ **Estado del VPS**\n- CPU: $cpu_usage%\n- Memoria: $mem_usage\n- Disco: $disk_usage"
#
