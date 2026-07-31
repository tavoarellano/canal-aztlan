#!/bin/sh
set -e

# Valores por defecto si no se definieron variables en Railway
export PORT="${PORT:-8000}"
export SOURCE_PASSWORD="${SOURCE_PASSWORD:-cambiame-fuente}"
export ADMIN_PASSWORD="${ADMIN_PASSWORD:-cambiame-admin}"
export ICECAST_HOSTNAME="${ICECAST_HOSTNAME:-localhost}"

# Rellenar la plantilla con las variables de entorno
envsubst '${PORT} ${SOURCE_PASSWORD} ${ADMIN_PASSWORD} ${ICECAST_HOSTNAME}' \
  < /etc/icecast.xml.template > /tmp/icecast.xml

echo "Canal Aztlán: Icecast escuchando en el puerto ${PORT}"
exec icecast2 -c /tmp/icecast.xml
