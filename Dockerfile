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
