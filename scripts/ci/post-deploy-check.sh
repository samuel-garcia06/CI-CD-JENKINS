#!/bin/bash
set -euo pipefail

APP_URL="${APP_URL:-http://localhost}"
REPORT_DIR="reports"
REPORT_FILE="${REPORT_DIR}/post-deploy-report.txt"

mkdir -p "${REPORT_DIR}"

{
  echo "Post-deploy verification"
  echo "Date: $(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  echo "Target: ${APP_URL}"
  echo
  echo "[1] Home page"
  curl --fail --silent --show-error "${APP_URL}" >/dev/null
  echo "OK"
  echo
  echo "[2] Health endpoint"
  curl --fail --silent --show-error "${APP_URL%/}/health" | grep -qi "ok"
  echo "OK"
} | tee "${REPORT_FILE}"
