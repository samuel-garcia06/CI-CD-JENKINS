#!/bin/bash
set -euo pipefail

APP_DIR="${REMOTE_APP_DIR:-/opt/angular-jenkins}"
DEPLOY_USER="${DEPLOY_USER:-$USER}"

echo "[1/5] Updating system packages..."
sudo apt-get update

echo "[2/5] Installing Docker prerequisites..."
sudo apt-get install -y ca-certificates curl gnupg

echo "[3/5] Installing Docker engine and compose plugin if needed..."
if ! command -v docker >/dev/null 2>&1; then
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  sudo chmod a+r /etc/apt/keyrings/docker.gpg
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
  sudo apt-get update
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
fi

echo "[4/5] Preparing deployment directory..."
sudo mkdir -p "${APP_DIR}/deploy" "${APP_DIR}/scripts/ci"
sudo chown -R "${DEPLOY_USER}:${DEPLOY_USER}" "${APP_DIR}"

echo "[5/5] Ensuring Docker access for deploy user..."
if ! id -nG "${DEPLOY_USER}" | grep -qw docker; then
  sudo usermod -aG docker "${DEPLOY_USER}"
  echo "User ${DEPLOY_USER} added to docker group. Re-login may be required."
fi

echo "VPS bootstrap complete for ${APP_DIR}"
