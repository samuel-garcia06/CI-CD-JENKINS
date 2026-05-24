#!/bin/bash
set -e

APP_DIR="${REMOTE_APP_DIR:-/opt/angular-jenkins}"
IMAGE_NAME="${IMAGE_NAME:-usuario/angular-jenkins}"
APP_ENV="${APP_ENV:-production}"
APP_PORT="${APP_PORT:-80}"
SKIP_PULL="${SKIP_PULL:-0}"

cd "$APP_DIR"
export IMAGE_NAME
export APP_ENV
export APP_PORT
if [ "$SKIP_PULL" != "1" ]; then
  docker compose pull
fi
docker compose up -d
docker compose ps
docker image prune -f
