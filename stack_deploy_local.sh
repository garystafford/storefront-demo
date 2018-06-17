#!/bin/sh

# Deploys the containers

set -e

# docker swarm init

docker stack deploy -c docker-compose-middleware.yml storefront
echo "Starting stack: middleware...pausing for 30 seconds..."
sleep 30

docker stack deploy -c docker-compose-services.yml storefront
echo "Starting stack: services...pausing for 10 seconds..."
sleep 10

docker stack ls
docker stack services storefront
docker container ls

echo "Script completed..."
echo "Services may take up to several minutes to start, fully..."
