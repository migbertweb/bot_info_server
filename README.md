# Bot de Telegram para monitoreo del sistema

Este bot de Telegram muestra información del sistema y los logs.

## Configuración del archivo `.env`

Para ejecutar esta aplicación, es necesario crear un archivo `.env` en la raíz del proyecto con las siguientes variables de entorno:

```env
TELEGRAM_BOT_TOKEN=tu-token-de-telegram
DOCKER_USERNAME=tu-usuario-docker
```

Variables requeridas:
TELEGRAM_BOT_TOKEN: Token de acceso para el bot de Telegram.
DOCKER_USERNAME: Nombre de usuario de Docker.

Ejemplo de uso con Docker Compose:
```yaml
---
services:
  telegram-bot:
    image: tu-usuario-dockerhub/nombre-repositorio:latest
    env_file:
      - .env
    volumes:
      - ./logs:/logs  # Monta la carpeta logs del host en /logs del contenedor
    restart: unless-stopped
```
Creación del archivo .env
Copia el archivo env.example a .env:
``` bash
cp env.example .env
```
Ubica la carpeta de los logs que deseas que el Bot te muestre y linkealos en el docker-compose (/logs:/logs)

ejecuta el contenedor
```bash 
docker-compose up -d```
