#!/bin/sh

# Deploys the containers

set -e

export KAFKA_ADVERTISED_HOST_NAME=kafka

docker-compose --file docker-compose-local.yml up -d

echo "Letting services start-up..."
sleep 5

docker ps

echo "Script completed..."
