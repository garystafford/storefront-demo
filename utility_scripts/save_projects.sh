#!/usr/bin/env bash

# Usage (from root of project): sh ./utility_scripts/save_projects.sh

COMMIT_MESSAGE="Updating for 2021.05 release"

cd /Users/garystafford/Documents/projects/storefront-demo || exit
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