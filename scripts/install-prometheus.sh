#!/usr/bin/env bash
# Installs Prometheus from the official release, configures it to scrape Node
# Exporter and runs it as a systemd service on :9090.
# Usage: sudo ./scripts/install-prometheus.sh
source "$(dirname "$0")/common.sh"

VERSION="${PROMETHEUS_VERSION:-3.15.0}"
NAME="prometheus-${VERSION}.linux-${ARCH}"

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
cd "$tmp"
fetch_verified "https://github.com/prometheus/prometheus/releases/download/v${VERSION}" "${NAME}.tar.gz" sha256sums.txt
tar -xzf "${NAME}.tar.gz"

system_user prometheus
install -m 0755 "${NAME}/prometheus" "${NAME}/promtool" /usr/local/bin/
install -d -o prometheus -g prometheus -m 0755 /etc/prometheus /var/lib/prometheus
install -o prometheus -g prometheus -m 0644 "${REPO}/prometheus/prometheus.yml" /etc/prometheus/prometheus.yml
promtool check config /etc/prometheus/prometheus.yml
install -m 0644 "${REPO}/prometheus/prometheus.service" /etc/systemd/system/prometheus.service

start_service prometheus
