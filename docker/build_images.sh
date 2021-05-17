#!/usr/bin/env bash

# Usage (from root of project): sh ./Docker/build_images.sh

IMAGE_TAG=3.0.0

cd /Users/garystafford/Documents/projects/storefront-demo-accounts || exit
pwd
docker build -f Docker/Dockerfile_base --no-cache -t garystafford/storefront-base:$IMAGE_TAG .
docker push garystafford/storefront-base:$IMAGE_TAG

./gradlew clean build
docker build -f Docker/Dockerfile --no-cache -t garystafford/storefront-accounts:$IMAGE_TAG .
docker push garystafford/storefront-accounts:$IMAGE_TAG

cd ../storefront-demo-orders || exit
pwd
./gradlew clean build
docker build -f Docker/Dockerfile --no-cache -t garystafford/storefront-orders:$IMAGE_TAG .
docker push garystafford/storefront-orders:$IMAGE_TAG

cd ../storefront-demo-fulfillment || exit
pwd
./gradlew clean build
docker build -f Docker/Dockerfile --no-cache -t garystafford/storefront-fulfillment:$IMAGE_TAG .
docker push garystafford/storefront-fulfillment:$IMAGE_TAG

cd ../storefront-eureka-server || exit
pwd
./gradlew clean build
docker build -f Docker/Dockerfile --no-cache -t garystafford/storefront-eureka:$IMAGE_TAG .
docker push garystafford/storefront-eureka:$IMAGE_TAG

cd ../storefront-zuul-proxy || exit
pwd
./gradlew clean build
docker build -f Docker/Dockerfile --no-cache -t garystafford/storefront-zuul:$IMAGE_TAG .
docker push garystafford/storefront-zuul:$IMAGE_TAG


#docker pull garystafford/storefront-fulfillment:$IMAGE_TAG \
#&& docker pull garystafford/storefront-accounts:$IMAGE_TAG \
#&& docker pull garystafford/storefront-orders:$IMAGE_TAG \
#&& docker container ls

#yes | docker system prune