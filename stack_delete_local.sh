#!/bin/sh

# Removes the containers

# set -e

docker stack storefront rm
docker ps

echo "Script completed..."
