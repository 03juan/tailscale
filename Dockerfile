FROM docker.io/tailscale/tailscale:stable as tailscale

FROM kennethreitz/httpbin:latest as httpbin

WORKDIR /app

RUN apt-get update \
  && apt-get install -y ca-certificates iptables \
  && rm -rf /var/lib/apt/lists/*_*

RUN mkdir -p /var/run/tailscale /var/cache/tailscale /var/lib/tailscale
# Copy Tailscale binaries from the tailscale image on Docker Hub.
COPY --from=tailscale /usr/local/bin/tailscaled /usr/local/bin/tailscale ./

# Copy binary to production image.
COPY start.sh ./
RUN chmod +x /app/start.sh

# Run on container startup.
CMD ["/app/start.sh"]
