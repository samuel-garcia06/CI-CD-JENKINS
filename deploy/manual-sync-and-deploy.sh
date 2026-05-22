#!/bin/bash
set -euo pipefail

REMOTE_HOST="${1:?Usage: manual-sync-and-deploy.sh user@host}"
APP_DIR="${REMOTE_APP_DIR:-/opt/angular-jenkins}"
IMAGE_NAME="${IMAGE_NAME:-angular-jenkins:manual}"

echo "[1/4] Syncing repository snapshot to ${REMOTE_HOST}:${APP_DIR}/source ..."
git archive --format=tar HEAD | ssh "${REMOTE_HOST}" "mkdir -p '${APP_DIR}/source' && tar -xf - -C '${APP_DIR}/source'"

echo "[2/4] Copying runtime deployment files ..."
scp docker-compose.yml deploy/remote-deploy.sh scripts/ci/post-deploy-check.sh "${REMOTE_HOST}:/tmp/"
ssh "${REMOTE_HOST}" "mkdir -p '${APP_DIR}/deploy' '${APP_DIR}/scripts/ci' && mv /tmp/docker-compose.yml '${APP_DIR}/docker-compose.yml' && mv /tmp/remote-deploy.sh '${APP_DIR}/deploy/remote-deploy.sh' && mv /tmp/post-deploy-check.sh '${APP_DIR}/scripts/ci/post-deploy-check.sh' && chmod +x '${APP_DIR}/deploy/remote-deploy.sh' '${APP_DIR}/scripts/ci/post-deploy-check.sh'"

echo "[3/4] Building image on server ..."
ssh "${REMOTE_HOST}" "docker build -f '${APP_DIR}/source/Dockerfile.alpine' -t '${IMAGE_NAME}' '${APP_DIR}/source'"

echo "[4/4] Starting container with Docker Compose ..."
ssh "${REMOTE_HOST}" "cd '${APP_DIR}' && IMAGE_NAME='${IMAGE_NAME}' APP_ENV=production APP_PORT=80 docker compose up -d"

echo "Manual deploy complete: ${REMOTE_HOST}"
