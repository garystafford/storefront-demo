#!/bin/sh

# Removes the containers

# set -e

docker rm -f $(docker ps | grep kafkadocker | awk '{print $1}') || echo "No containers found..."

docker ps

echo "Script completed..."
