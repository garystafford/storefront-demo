#!/bin/sh

# Destroys the storefront Docker stack

# usage: sh ./stack_delete_local.sh

set -e

docker stack rm storefront

echo "Destroying the stack...pausing for 30 seconds..."
sleep 30

docker ps

echo "Script completed..."
