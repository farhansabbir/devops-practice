#!/usr/bin/env bash
# Installs Grafana from Grafana's APT repository, provisions the Prometheus and
# Loki datasources and the monitoring dashboard, and runs it on :3000.
# Usage: sudo ./scripts/install-grafana.sh
source "$(dirname "$0")/common.sh"

grafana_apt_repo
apt-get install -y grafana

install -m 0640 -g grafana "${REPO}/grafana/provisioning/datasources/datasources.yaml" \
  /etc/grafana/provisioning/datasources/datasources.yaml
install -m 0640 -g grafana "${REPO}/grafana/provisioning/dashboards/dashboards.yaml" \
  /etc/grafana/provisioning/dashboards/dashboards.yaml
install -d -o grafana -g grafana -m 0755 /var/lib/grafana/dashboards
install -o grafana -g grafana -m 0644 "${REPO}"/grafana/dashboards/*.json /var/lib/grafana/dashboards/

start_service grafana-server
