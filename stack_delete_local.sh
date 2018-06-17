#!/bin/sh

# Removes the containers

# set -e

docker stack rm storefront

echo "Destroying stack...pausing for 30 seconds..."
sleep 30

docker ps

echo "Script completed..."
