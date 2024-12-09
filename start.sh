#!/bin/sh

echo "Enabling IP forwarding"
echo 'net.ipv4.ip_forward = 1' | tee -a /etc/sysctl.d/99-tailscale.conf
echo 'net.ipv6.conf.all.forwarding = 1' | tee -a /etc/sysctl.d/99-tailscale.conf
sysctl -p /etc/sysctl.d/99-tailscale.conf

echo "Starting tailscale daemon"
/app/tailscaled --state=/var/lib/tailscale/tailscaled.state --socket=/var/run/tailscale/tailscaled.sock &

TAILSCALE_HOSTNAME="fly-exit-${FLY_REGION}"

echo "Starting tailscale exit with hostname ${TAILSCALE_HOSTNAME}"
/app/tailscale up --authkey=${TAILSCALE_AUTHKEY} --advertise-exit-node --hostname="${TAILSCALE_HOSTNAME}"

echo "Sleep forever"
while true; do
  sleep 3600
done
