# Install Tailscale
# https://tailscale.com/kb/1107/heroku/
FROM alpine:latest as tailscale
WORKDIR /app
COPY . ./
ENV TSFILE=tailscale_latest_amd64.tgz
RUN wget https://pkgs.tailscale.com/stable/${TSFILE} && \
  tar xzf ${TSFILE} --strip-components=1
COPY . ./

FROM n8nio/n8n:1.64.3

USER root

# Specifying work directory
WORKDIR /data
COPY --from=tailscale /app/tailscaled /data/tailscaled
COPY --from=tailscale /app/tailscale /data/tailscale
RUN mkdir -p /var/run/tailscale /var/cache/tailscale /var/lib/tailscale

WORKDIR /home/node/packages/cli
ENTRYPOINT []

EXPOSE 5678/tcp

COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh
CMD ["/entrypoint.sh"]
