#!/bin/bash
set -e

APP_DIR="${REMOTE_APP_DIR:-/opt/angular-jenkins}"
IMAGE_NAME="${IMAGE_NAME:-usuario/angular-jenkins}"
APP_ENV="${APP_ENV:-production}"
APP_PORT="${APP_PORT:-80}"

cd "$APP_DIR"
export IMAGE_NAME
export APP_ENV
export APP_PORT
docker compose pull
docker compose up -d
docker compose ps
docker image prune -f
