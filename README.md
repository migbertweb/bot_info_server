# Bot de Telegram para Monitoreo del Sistema

Bot de Telegram diseñado para monitorear el estado del sistema y gestionar logs de manera remota a través de comandos simples.

## 📋 Descripción

Este bot permite monitorear tu servidor o VPS desde Telegram, proporcionando información sobre:
- Estado del sistema (CPU, memoria, disco, carga del sistema)
- Logs del sistema en tiempo real
- Métricas de red y temperatura
- Procesos en ejecución

## ✨ Características

- 🔐 **Autenticación**: Solo usuarios autorizados pueden usar el bot
- 📊 **Monitoreo en tiempo real**: Consulta el estado del sistema cuando lo necesites
- 📜 **Gestión de logs**: Visualiza los últimos logs del sistema
- 🐳 **Dockerizado**: Fácil despliegue con Docker y Docker Compose
- ⚡ **Ligero**: Basado en Alpine Linux para un contenedor mínimo

## 🚀 Instalación

### Requisitos Previos

- Docker y Docker Compose instalados
- Un bot de Telegram (creado con [@BotFather](https://t.me/BotFather))
- Chat ID de Telegram (puedes obtenerlo con [@userinfobot](https://t.me/userinfobot))

### Configuración

1. **Clonar el repositorio**:
```bash
git clone https://github.com/migbertweb/bot_info_server.git
cd bot_info_server
```

2. **Crear archivo `.env`**:
```bash
cp env.example .env
```

3. **Configurar variables de entorno** en el archivo `.env`:
```env
TELEGRAM_TOKEN=tu-token-de-telegram
CHAT_ID=tu-chat-id
```

4. **Configurar la ruta de logs**:
   - Edita `docker-compose.yml` y ajusta la ruta de logs en el volumen:
   ```yaml
   volumes:
     - /ruta/a/tus/logs:/logs
   ```

5. **Ejecutar con Docker Compose**:
```bash
docker-compose up -d
```

## 📖 Uso

Una vez iniciado el bot, puedes usar los siguientes comandos en Telegram:

- `/start` - Muestra el mensaje de bienvenida y los comandos disponibles
- `/status` - Muestra el estado actual del sistema (CPU, memoria, disco, etc.)
- `/logs` - Muestra los últimos logs del sistema

### Ejemplo de salida de `/status`:
```
🖥️ Estado del Sistema
- CPU: 15.2%
- Memoria: 45.30%
- Versión del kernel: Linux 6.17.7-zen1-1-zen
- Disco: 45%
- Carga del sistema: 0.52
- Uptime: up 5 days, 3 hours
- Usuarios conectados: 2
- Red: RX 1024.50 MB / TX 512.25 MB
- Temperatura CPU: 45°C
- Procesos en ejecución: 156
```

## 🏗️ Estructura del Proyecto

```
bot_info_server/
├── bot.py                 # Código principal del bot
├── Dockerfile             # Configuración de la imagen Docker
├── docker-compose.yml     # Configuración de Docker Compose
├── LICENSE                # Licencia MIT
├── README.md              # Este archivo
├── scripts/
│   ├── logs.sh           # Script para obtener logs
│   └── status.sh         # Script para obtener estado del sistema
└── logs/                 # Directorio de logs (montado como volumen)
```

## 🔧 Configuración Avanzada

### Personalizar Scripts

Los scripts en `scripts/` pueden ser modificados para agregar más funcionalidades:

- `status.sh`: Modifica las métricas que se muestran
- `logs.sh`: Ajusta qué logs se muestran y cuántas líneas

### Variables de Entorno

| Variable | Descripción | Requerido |
|----------|-------------|-----------|
| `TELEGRAM_TOKEN` | Token del bot de Telegram | Sí |
| `CHAT_ID` | ID del chat autorizado | Sí |

## 🐛 Solución de Problemas

### El bot no responde
- Verifica que el token de Telegram sea correcto
- Asegúrate de que el CHAT_ID sea el correcto
- Revisa los logs del contenedor: `docker-compose logs`

### Error al ejecutar scripts
- Verifica que los scripts tengan permisos de ejecución
- Asegúrate de que la ruta de logs esté correctamente montada
- Revisa que las herramientas del sistema estén disponibles en el contenedor

### Los logs no se muestran
- Verifica que el directorio de logs esté montado correctamente
- Asegúrate de que existan archivos `.log` en el directorio
- Revisa los permisos del directorio de logs

## 📝 Desarrollo

### Construir la imagen manualmente:
```bash
docker build -t bot_info_server .
```

### Ejecutar sin Docker Compose:
```bash
docker run -d \
  --name gestionvps-bot \
  --env-file .env \
  -v ./logs:/logs \
  -v ./scripts:/scripts \
  bot_info_server
```

## 📄 Licencia

Este proyecto está licenciado bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para más detalles.

**Recomendación para Proyectos Educativos**: Se recomienda encarecidamente, aunque no es obligatorio, que las obras derivadas mantengan este mismo espíritu de código libre y abierto, especialmente cuando se utilicen con fines educativos o de investigación.

## 👤 Autor

**Migbertweb**

- Repositorio: [https://github.com/migbertweb/bot_info_server](https://github.com/migbertweb/bot_info_server)

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Por favor:
1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## ⚠️ Notas Importantes

- Este bot requiere acceso a comandos del sistema para funcionar correctamente
- Asegúrate de mantener seguras tus credenciales de Telegram
- El bot está diseñado para uso en entornos controlados
- Se recomienda usar este bot solo en servidores de confianza
