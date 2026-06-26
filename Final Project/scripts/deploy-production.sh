#!/bin/bash

set -euo pipefail

IMAGE_NAME="${IMAGE_NAME:-arnaudve/devops-lab02}"
IMAGE_TAG="${IMAGE_TAG:-latest}"

PROD_HOST="${PROD_HOST:-192.168.56.30}"
PROD_USER="${PROD_USER:-vagrant}"
SSH_KEY="${SSH_KEY:-/var/lib/jenkins/.ssh/production_key}"

CONTAINER_NAME="${CONTAINER_NAME:-devops-final-app}"
APP_PORT="${APP_PORT:-3000}"

echo "======================================"
echo " Deploying application to production"
echo "======================================"
echo "Image: ${IMAGE_NAME}:${IMAGE_TAG}"
echo "Production server: ${PROD_USER}@${PROD_HOST}"
echo "Container name: ${CONTAINER_NAME}"
echo "Application port: ${APP_PORT}"
echo "======================================"

ssh -i "${SSH_KEY}" \
    -o IdentitiesOnly=yes \
    -o StrictHostKeyChecking=no \
    "${PROD_USER}@${PROD_HOST}" "
        set -e

        echo '[1/4] Pulling Docker image...'
        docker pull ${IMAGE_NAME}:${IMAGE_TAG}

        echo '[2/4] Removing old container if it exists...'
        docker rm -f ${CONTAINER_NAME} 2>/dev/null || true

        echo '[3/4] Starting new container...'
        docker run -d \
          --name ${CONTAINER_NAME} \
          --restart unless-stopped \
          -p ${APP_PORT}:3000 \
          ${IMAGE_NAME}:${IMAGE_TAG}

        echo '[4/4] Current running containers:'
        docker ps
    "

echo "Deployment command executed successfully."