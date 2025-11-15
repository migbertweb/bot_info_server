#!/bin/sh
#
# Archivo: logs.sh
#
# Descripción: Script que busca y muestra las últimas 5 líneas de todos los archivos
# .log encontrados en el directorio /logs. Ordena los archivos por fecha de modificación
# y formatea la salida para su visualización en Telegram.
#
# Autor: migbertweb
#
# Fecha: 2024-12-19
#
# Repositorio: https://github.com/migbertweb/bot_info_server
#
# Licencia: MIT License
#
# Uso: Ejecutado por el bot de Telegram mediante el comando /logs para mostrar
# los últimos registros del sistema de forma remota.
#
# Nota: Este proyecto usa Licencia MIT. Se recomienda (no obliga) mantener 
# derivados como código libre, especialmente para fines educativos.
#

set -e # Detener el script si hay un error

# Definir ruta de logs (se almacenan en /logs dentro del contenedor)
LOG_DIR="/logs"

# Verificar si el directorio de logs existe
if [ ! -d "$LOG_DIR" ]; then
  echo "Error: El directorio de logs no existe en $LOG_DIR."
  exit 1
fi

# Buscar archivos .log en el directorio
# LOG_FILES=$(find "$LOG_DIR" -name "*.log" -type f)
LOG_FILES=$(find "$LOG_DIR" -name "*.log" -type f -exec ls -t {} +)
# Verificar si se encontraron archivos .log
if [ -z "$LOG_FILES" ]; then
  echo "No se encontraron archivos .log en $LOG_DIR."
  exit 1
fi

# Mostrar las últimas 5 líneas de cada archivo .log
for LOG_FILE in $LOG_FILES; do
  echo -e "📜 **Últimos logs de $(basename "$LOG_FILE")**"
  echo "----------------------------------------"
  tail -n 5 "$LOG_FILE"
  echo -e "\n"
done
# for LOG_FILE in $LOG_FILES; do
#   echo -e "📜 **Últimos logs de $(basename "$LOG_FILE")**\n$(tail -n 5 "$LOG_FILE")\n"
# done

#set -e  # Detener el script si hay un error
#
## Definir ruta de logs (se almacenan en /logs dentro del contenedor)
#LOG_DIR="/logs"
#LOG_FILE="$LOG_DIR/system.log"
#
## Verificar si existen logs
#if [ ! -f "$LOG_FILE" ]; then
#    echo "No hay logs disponibles."
#    exit 1
#fi
#
## Mostrar últimas 20 líneas de logs
#echo -e "📜 **Últimos logs del sistema**\n$(tail -n 20 $LOG_FILE)"
