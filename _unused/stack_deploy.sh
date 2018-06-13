#!/bin/sh

# Deploys the kafka_stack to worker3 swarm node

set -e

docker-machine env manager1
eval $(docker-machine env manager1)

export KAFKA_ADVERTISED_HOST_NAME=$(docker-machine ip worker3)

docker stack deploy --compose-file=docker-compose.yml kafka_stack

echo "Letting services start-up..."
sleep 5

docker stack ls
docker stack ps kafka_stack --no-trunc
docker service ls

echo "Script completed..."
