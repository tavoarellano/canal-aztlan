# Canal Aztlán — Servidor de streaming Icecast para Railway
FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends icecast2 gettext-base ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Plantilla de configuración (se rellena con variables de entorno al arrancar)
COPY icecast.xml.template /etc/icecast.xml.template
COPY entrypoint.sh /entrypoint.sh

# Página web de Canal Aztlán servida por el propio Icecast
COPY web/index.html /usr/share/icecast2/web/index.html

RUN chmod +x /entrypoint.sh && \
    mkdir -p /var/log/icecast2 && \
    chown -R icecast2:icecast /var/log/icecast2 /usr/share/icecast2

USER icecast2

EXPOSE 8000

CMD ["/entrypoint.sh"]
