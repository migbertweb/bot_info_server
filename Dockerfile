#
# Archivo: Dockerfile
#
# Descripción: Configuración de la imagen Docker para el bot de Telegram de monitoreo.
# Utiliza Alpine Linux como base para una imagen ligera, instala Python 3, dependencias
# del sistema necesarias para los scripts de monitoreo (bash, coreutils, procps, util-linux,
# lm-sensors, bc) y las librerías de Python (python-telegram-bot, python-dotenv).
# Configura un entorno virtual y prepara el contenedor para ejecutar el bot.
#
# Autor: migbertweb
#
# Fecha: 2024-12-19
#
# Repositorio: https://github.com/migbertweb/bot_info_server
#
# Licencia: MIT License
#
# Uso: Construye la imagen Docker del bot de monitoreo. Se usa con docker-compose
# o directamente con docker build para crear el contenedor del bot.
#
# Nota: Este proyecto usa Licencia MIT. Se recomienda (no obliga) mantener 
# derivados como código libre, especialmente para fines educativos.
#

# Usar Alpine Linux como base
FROM alpine:latest

# Instalar dependencias
RUN apk add --no-cache \
  python3 \
  py3-pip \
  bash \
  coreutils \
  procps \
  util-linux \
  lm-sensors \
  bc

# Crear un entorno virtual
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Instalar librerías de Python en el entorno virtual
RUN pip install --upgrade pip && \
  pip install python-telegram-bot python-dotenv

# Crear directorio de trabajo
WORKDIR /app

# Copiar scripts y código
COPY scripts /scripts
COPY bot.py /app/bot.py
# COPY .env /app/.env

# Hacer ejecutables los scripts
RUN chmod +x /scripts/*.sh

# Montar la carpeta de logs
VOLUME /logs

# Comando por defecto
CMD ["python3", "bot.py"]
