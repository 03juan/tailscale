FROM docker.io/tailscale/tailscale:stable as tailscale

FROM alpine:latest

WORKDIR /app

RUN apk update && apk add ca-certificates iptables ip6tables --no-cache

RUN mkdir -p /var/run/tailscale /var/cache/tailscale /var/lib/tailscale
# Copy Tailscale binaries from the tailscale image on Docker Hub.
COPY --from=tailscale /usr/local/bin/tailscaled /usr/local/bin/tailscale ./

# Copy binary to production image.
COPY start.sh ./
RUN chmod +x /app/start.sh

# Run on container startup.
CMD ["/app/start.sh"]
