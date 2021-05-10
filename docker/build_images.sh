#!/usr/bin/env bash

# Usage (from root of project): sh ./Docker/build_images.sh

cd /Users/garystafford/Documents/projects/storefront-demo-accounts || exit
pwd
./gradlew clean build
docker build -f Docker/Dockerfile --no-cache -t garystafford/storefront-accounts:3.0.0 .
docker push garystafford/storefront-accounts:3.0.0

cd ../storefront-demo-orders || exit
pwd
./gradlew clean build
docker build -f Docker/Dockerfile --no-cache -t garystafford/storefront-orders:3.0.0 .
docker push garystafford/storefront-orders:3.0.0

cd ../storefront-demo-fulfillment || exit
pwd
./gradlew clean build
docker build -f Docker/Dockerfile --no-cache -t garystafford/storefront-fulfillment:3.0.0 .
docker push garystafford/storefront-fulfillment:3.0.0


#docker pull garystafford/storefront-fulfillment:3.0.0 \
#&& docker pull garystafford/storefront-accounts:3.0.0 \
#&& docker pull garystafford/storefront-orders:3.0.0 \
#&& docker container ls

#yes | docker system prune