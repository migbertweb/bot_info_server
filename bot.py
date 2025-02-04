import os
import subprocess
from dotenv import load_dotenv
from telegram import Update
from telegram.ext import ApplicationBuilder, CommandHandler, ContextTypes
from functools import wraps

# Cargar variables de entorno desde el archivo .env
load_dotenv()

TELEGRAM_TOKEN = os.getenv("TELEGRAM_TOKEN")
AUTHORIZED_CHAT_ID = os.getenv("CHAT_ID")

if not TELEGRAM_TOKEN:
    raise ValueError(
        "El token de Telegram no está configurado. Verifique su archivo .env."
    )


# Decorador para verificar autorización
def authorized_only(func):
    @wraps(func)
    async def wrapper(
        update: Update, context: ContextTypes.DEFAULT_TYPE, *args, **kwargs
    ):
        if str(update.effective_chat.id) != AUTHORIZED_CHAT_ID:
            await update.message.reply_text("No estás autorizado para usar este bot.")
            return
        return await func(update, context, *args, **kwargs)

    return wrapper


# Funcón para ejecutar scripts con manejo de tiempo de espera
def run_script(script_path):
    try:
        result = subprocess.run(
            ["bash", script_path], capture_output=True, text=True, timeout=30
        )
        return result.stdout if result.returncode == 0 else result.stderr
    except subprocess.TimeoutExpired:
        return "El script tardó demasiado en ejecutarse y fue detenido."
    except Exception as e:
        return f"Error ejecutando el script: {e}"


# Comando /start
@authorized_only
async def start(update: Update, context: ContextTypes.DEFAULT_TYPE):
    welcome_message = (
        "¡Bienvenido al bot!\n\n"
        "Este bot está diseñado para ayudarte a gestionar tus scripts.\n"
        "Usa los siguientes comandos para interactuar conmigo:\n"
        "/status - Verifica el estado del sistema.\n"
        "/logs - Muestra los logs del sistema.\n\n"
        "¡Éxito! El bot está listo para usarse."
    )
    await update.message.reply_text(welcome_message)


# Comando /status
@authorized_only
async def status(update: Update, context: ContextTypes.DEFAULT_TYPE):
    output = run_script("/scripts/status.sh")
    await update.message.reply_text(output)


# Comando /logs
@authorized_only
async def logs(update: Update, context: ContextTypes.DEFAULT_TYPE):
    output = run_script("/scripts/logs.sh")
    # await update.message.reply_text(output)
    # Limitar la salida a 10,000 caracteres (por ejemplo)
    output = output[:10000]
    #
    # Dividir la salida en partes de 4096 caracteres
    max_length = 2024
    messages = [output[i : i + max_length] for i in range(0, len(output), max_length)]

    # Enviar cada parte como un mensaje separado
    for message in messages:
        await update.message.reply_text(message, parse_mode="Markdown")


# Configuración del bot
if __name__ == "__main__":
    app = ApplicationBuilder().token(TELEGRAM_TOKEN).build()
    # Agregar manejadores de comandos
    app.add_handler(CommandHandler("start", start))
    app.add_handler(CommandHandler("status", status))
    app.add_handler(CommandHandler("logs", logs))

    print("Bot en funcionamiento...")
    app.run_polling()
