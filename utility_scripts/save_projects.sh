#!/usr/bin/env bash

# Usage (from root of project): sh ./Docker/save_projects.sh

COMMIT_MESSAGE="Updating for 2021.05 release"

cd /Users/garystafford/Documents/projects/storefront-kafka-docker || exit
pwd
git add -A && git commit -m"${COMMIT_MESSAGE}" && git push

cd ../storefront-demo-accounts || exit
pwd
git add -A && git commit -m"${COMMIT_MESSAGE}" && git push

cd ../storefront-demo-orders || exit
pwd
git add -A && git commit -m"${COMMIT_MESSAGE}" && git push

cd ../storefront-demo-fulfillment || exit
pwd
git add -A && git commit -m"${COMMIT_MESSAGE}" && git push

cd ../storefront-eureka-server || exit
pwd
git add -A && git commit -m"${COMMIT_MESSAGE}" && git push

cd ../storefront-zuul-proxy || exit
pwd
git add -A && git commit -m"${COMMIT_MESSAGE}" && git push

#docker pull garystafford/storefront-fulfillment:3.0.0 \
#&& docker pull garystafford/storefront-accounts:3.0.0 \
#&& docker pull garystafford/storefront-orders:3.0.0 \
#&& docker container ls

#yes | docker system prune
