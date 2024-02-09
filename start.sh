#!/bin/sh

echo "Enabling IP forwarding"
echo 'net.ipv4.ip_forward = 1' | tee -a /etc/sysctl.d/99-tailscale.conf
echo 'net.ipv6.conf.all.forwarding = 1' | tee -a /etc/sysctl.d/99-tailscale.conf
sysctl -p /etc/sysctl.d/99-tailscale.conf

echo "Starting tailscale daemon"
/app/tailscaled --state=/var/lib/tailscale/tailscaled.state --socket=/var/run/tailscale/tailscaled.sock &

echo "Starting tailscale exit node"
/app/tailscale up --authkey=${TAILSCALE_AUTHKEY} --advertise-exit-node --hostname="fly-exit-eze"

echo "Starting httpbin via gunicorn..."
exec gunicorn -b "0.0.0.0:8080" "httpbin:app" -k "gevent"
