#!/usr/bin/env bash

# Usage (from root of project): sh ./Docker/build_images.sh

cd /Users/garystafford/Documents/projects/storefront-kafka-docker || exit
pwd
git add -A && git commit -m"Updating for 2021.05 release"

cd ../storefront-demo-accounts || exit
pwd
git add -A && git commit -m"Updating for 2021.05 release"

cd ../storefront-demo-orders || exit
pwd
git add -A && git commit -m"Updating for 2021.05 release"

cd ../storefront-demo-fulfillment || exit
pwd
git add -A && git commit -m"Updating for 2021.05 release"


#docker pull garystafford/storefront-fulfillment:3.0.0 \
#&& docker pull garystafford/storefront-accounts:3.0.0 \
#&& docker pull garystafford/storefront-orders:3.0.0 \
#&& docker container ls

#yes | docker system prune