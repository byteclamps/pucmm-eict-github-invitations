FROM ortussolutions/commandbox:lucee6 AS builder

# Metadata
LABEL maintainer="Gustavo Henriquez <gustavojoseh@gmail.com>"
LABEL repository="https://github.com/byteclamps/pucmm-eict-github-invitations"

# Environment variables
ENV BOX_SERVER_APP_CFENGINE="lucee@6"
ENV FINALIZE_STARTUP=true

# Copy application files to root - Uses .dockerignore to ignore files
WORKDIR /app
COPY . .

RUN $BUILD_DIR/run.sh

FROM eclipse-temurin:21.0.1_12-jdk-jammy AS app

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y nginx gettext && \
    # Clean up unnecessary files to reduce image size
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/templates
RUN mkdir -p /etc/certificates

# COPY our generated files
COPY --from=builder /app /app
COPY --from=builder /app/nginx/default.conf.template /etc/nginx/templates/default.conf.template
COPY --from=builder /app/nginx/nginx.conf /etc/nginx/nginx.conf
COPY --from=builder /app/certificates/local /etc/nginx/ssl
COPY --from=builder /app/certificates/local /etc/certificates
COPY --from=builder /app/startup.sh /usr/local/bin/startup.sh
COPY --from=builder /usr/local/lib/serverHome /usr/local/lib/serverHome

RUN mkdir -p /usr/local/lib/CommandBox/lib

COPY --from=builder /usr/local/lib/CommandBox/lib/runwar-5.0.8.jar /usr/local/lib/CommandBox/lib/runwar-5.0.8.jar
COPY --from=builder /usr/local/bin/startup-final.sh /usr/local/bin/run.sh

# Restore working directory environment
WORKDIR /app

ENV HEALTHCHECK_URI="https://127.0.0.1:8890"
HEALTHCHECK --interval=20s --timeout=30s --retries=15 CMD curl --insecure --fail ${HEALTHCHECK_URI} || exit 1

RUN chmod +x /usr/local/bin/startup.sh

CMD /usr/local/bin/startup.sh
