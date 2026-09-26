#!/usr/bin/env bash
# Installs Node Exporter from the official release and runs it as a systemd
# service on :9100.   Usage: sudo ./scripts/install-node-exporter.sh
source "$(dirname "$0")/common.sh"

VERSION="${NODE_EXPORTER_VERSION:-1.12.1}"
NAME="node_exporter-${VERSION}.linux-${ARCH}"

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
cd "$tmp"
fetch_verified "https://github.com/prometheus/node_exporter/releases/download/v${VERSION}" "${NAME}.tar.gz" sha256sums.txt
tar -xzf "${NAME}.tar.gz"

system_user node_exporter
install -m 0755 "${NAME}/node_exporter" /usr/local/bin/node_exporter
install -m 0644 "${REPO}/node_exporter/node_exporter.service" /etc/systemd/system/node_exporter.service

start_service node_exporter
