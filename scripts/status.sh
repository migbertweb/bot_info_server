#!/bin/sh
set -e  # Detener el script si hay un error

# Obtener métricas del sistema
cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
mem_usage=$(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2}')
disk_usage=$(df -h / | awk 'NR==2{print $5}')

# Crear mensaje
echo -e "🖥️ **Estado del VPS**\n- CPU: $cpu_usage%\n- Memoria: $mem_usage\n- Disco: $disk_usage"
