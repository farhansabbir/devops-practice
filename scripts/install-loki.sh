#!/usr/bin/env bash
# Installs Loki from the official release as a systemd service on
# 127.0.0.1:3100, and Grafana Alloy (from Grafana's APT repository) to ship the
# systemd journal and /var/log files into it.
# Usage: sudo ./scripts/install-loki.sh
source "$(dirname "$0")/common.sh"

VERSION="${LOKI_VERSION:-3.7.8}"
ZIP="loki-linux-${ARCH}.zip"

# ---- Loki
apt-get install -y unzip
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
cd "$tmp"
fetch_verified "https://github.com/grafana/loki/releases/download/v${VERSION}" "${ZIP}" SHA256SUMS
unzip -q "${ZIP}"

system_user loki
install -m 0755 "loki-linux-${ARCH}" /usr/local/bin/loki
install -d -m 0755 /etc/loki
install -d -o loki -g loki -m 0750 /var/lib/loki
install -m 0644 "${REPO}/loki/loki-config.yaml" /etc/loki/loki-config.yaml
loki -config.file=/etc/loki/loki-config.yaml -verify-config
install -m 0644 "${REPO}/loki/loki.service" /etc/systemd/system/loki.service
start_service loki

# ---- Alloy (the log shipper)
grafana_apt_repo
apt-get install -y alloy
# Reading the journal and /var/log needs these groups.
usermod -aG systemd-journal,adm alloy
install -m 0644 "${REPO}/alloy/config.alloy" /etc/alloy/config.alloy
alloy fmt /etc/alloy/config.alloy >/dev/null
start_service alloy
