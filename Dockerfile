FROM node:20-slim
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates \
    && update-ca-certificates && rm -rf /var/lib/apt/lists/*
ENV SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build
ENV WRANGLER_SEND_METRICS=false
EXPOSE 8787
CMD ["sh","-c","printf 'CALLS_APP_ID=%s\\nCALLS_APP_SECRET=%s\\n' \"$CALLS_APP_ID\" \"$CALLS_APP_SECRET\" > .dev.vars && npx wrangler dev --ip 0.0.0.0 --port 8787 --persist-to /data"]
