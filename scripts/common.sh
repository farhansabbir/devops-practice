# Shared helpers for the install scripts. Sourced, not run.

set -euo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "run as root: sudo $0" >&2
  exit 1
fi

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ARCH="$(dpkg --print-architecture)" # amd64, arm64

# fetch_verified BASE_URL FILE SUMS_FILE: downloads FILE into the current
# directory and checks it against the release's published SHA-256 list.
fetch_verified() {
  local base="$1" file="$2" sums="$3"
  curl -fsSLO "${base}/${file}"
  curl -fsSL -o sums.txt "${base}/${sums}"
  awk -v f="${file}" '$2 == f || $2 == "*" f { print $1 "  " f }' sums.txt | sha256sum -c -
}

# system_user NAME: a login-less system account for a service.
system_user() {
  id "$1" >/dev/null 2>&1 || useradd --system --no-create-home --shell /usr/sbin/nologin "$1"
}

# grafana_apt_repo: Grafana Labs' signed APT repository (grafana, alloy).
grafana_apt_repo() {
  if [[ ! -f /etc/apt/sources.list.d/grafana.list ]]; then
    apt-get install -y gpg curl
    mkdir -p /etc/apt/keyrings
    curl -fsSL https://apt.grafana.com/gpg.key | gpg --dearmor -o /etc/apt/keyrings/grafana.gpg
    echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" \
      > /etc/apt/sources.list.d/grafana.list
  fi
  apt-get update
}

# start_service NAME: enables NAME at boot and (re)starts it, so a re-run picks
# up new binaries and configuration.
start_service() {
  systemctl daemon-reload
  systemctl enable "$1"
  systemctl restart "$1"
  systemctl --no-pager --lines=0 status "$1"
}
