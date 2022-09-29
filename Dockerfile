ARG NODE_VERSION=16
FROM n8nio/base:${NODE_VERSION}

ARG PGPASSWORD
ARG PGHOST
ARG PGPORT
ARG PGDATABASE
ARG PGUSER

ARG USERNAME
ARG PASSWORD

ENV DB_TYPE=postgresdb
ENV DB_POSTGRESDB_DATABASE=$PGDATABASE
ENV DB_POSTGRESDB_HOST=$PGHOST
ENV DB_POSTGRESDB_PORT=$PGPORT
ENV DB_POSTGRESDB_USER=$PGUSER
ENV DB_POSTGRESDB_PASSWORD=$PGPASSWORD

ENV N8N_BASIC_AUTH_ACTIVE=true
ENV N8N_BASIC_AUTH_USER=$USERNAME
ENV N8N_BASIC_AUTH_PASSWORD=$PASSWORD
ENV DOMAIN_NAME=https://n8n-production-be71.up.railway.app/

ARG N8N_VERSION=0.195.5
RUN if [ -z "$N8N_VERSION" ] ; then echo "The N8N_VERSION argument is missing!" ; exit 1; fi

ENV NODE_ENV=production
RUN set -eux; \
  apkArch="$(apk --print-arch)"; \
  case "$apkArch" in \
  'armv7') apk --no-cache add --virtual build-dependencies python3 build-base;; \
  esac && \
  npm install -g --omit=dev n8n@${N8N_VERSION} && \
  case "$apkArch" in \
  'armv7') apk del build-dependencies;; \
  esac && \
  find /usr/local/lib/node_modules/n8n -type f -name "*.ts" -o -name "*.js.map" -o -name "*.vue" | xargs rm && \
  rm -rf /root/.npm

CMD ["n8n", "start"]
