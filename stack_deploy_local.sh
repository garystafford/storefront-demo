#!/bin/sh

# Deploys the containers

set -e

docker swarm init
docker stack deploy -c docker-compose.yml storefront

echo "Letting services start-up..."
sleep 5

docker ps

echo "Script completed..."
