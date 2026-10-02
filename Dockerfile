FROM node:24-bookworm-slim

# Paperclip 2026.916.1 on Node 24, with the Hermes and Kimi CLIs on PATH.
# The server uses an external DATABASE_URL and does not start a database of its own.
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    python3 \
    python3-pip \
    tini \
  && rm -rf /var/lib/apt/lists/* \
  && npm install --global --omit=dev paperclipai@2026.916.1 @moonshot-ai/kimi-code@2.1.1 \
  && python3 -m pip install --no-cache-dir --break-system-packages hermes-agent==0.19.0 \
  && paperclipai --version \
  && command -v kimi \
  && command -v hermes \
  && mkdir -p /paperclip

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod 0755 /usr/local/bin/entrypoint.sh

ENV NODE_ENV=production \
    HOST=0.0.0.0 \
    PORT=3100 \
    SERVE_UI=true \
    PAPERCLIP_HOME=/paperclip \
    PAPERCLIP_DEPLOYMENT_MODE=authenticated \
    PAPERCLIP_DEPLOYMENT_EXPOSURE=private \
    PAPERCLIP_BIND=lan \
    NODE_OPTIONS=--max-old-space-size=192

WORKDIR /paperclip
EXPOSE 3100
ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/entrypoint.sh"]
