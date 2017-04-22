#!/bin/sh

# Deploys the containers

set -e

export KAFKA_ADVERTISED_HOST_NAME=kafka

docker-compose -f docker-compose-local.yml up --force-recreate -d

echo "Letting services start-up..."
sleep 5

docker ps

echo "Script completed..."
