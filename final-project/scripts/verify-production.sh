#!/bin/bash

set -euo pipefail

PROD_HOST="${PROD_HOST:-192.168.56.30}"
APP_PORT="${APP_PORT:-3000}"
HEALTH_URL="http://${PROD_HOST}:${APP_PORT}/health"
HOME_URL="http://${PROD_HOST}:${APP_PORT}"

echo "======================================"
echo " Verifying production deployment"
echo "======================================"
echo "Home URL: ${HOME_URL}"
echo "Health URL: ${HEALTH_URL}"
echo "======================================"

for attempt in {1..10}
do
    echo "Attempt ${attempt}/10..."

    if curl -fsS "${HEALTH_URL}" > /tmp/health-response.json
    then
        echo "Health endpoint is reachable."
        cat /tmp/health-response.json
        echo
        echo "Checking home page..."
        curl -fsS "${HOME_URL}"
        echo
        echo "Production verification succeeded."
        exit 0
    fi

    echo "Application is not ready yet. Waiting..."
    sleep 3
done

echo "Production verification failed."
exit 1