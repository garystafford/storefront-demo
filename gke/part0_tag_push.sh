#!/bin/bash
#
# Part 0: Push existing Dockerhub images to Google Container Registry (GCR)

# Constants - CHANGE ME!
readonly PROJECT='gke-confluent-atlas'
readonly GCP_HOST='gcr.io'

gcloud auth configure-docker

# Tag existing images
docker tag garystafford/storefront-accounts:gke-2.2.0 \
  $GCP_HOST/$PROJECT/storefront-accounts:gke-2.2.0
docker tag garystafford/storefront-orders:gke-2.2.0 \
  $GCP_HOST/$PROJECT/storefront-orders:gke-2.2.0
docker tag garystafford/storefront-fulfillment:gke-2.2.1 \
  $GCP_HOST/$PROJECT/storefront-fulfillment:gke-2.2.1

# Push images to GCR
docker push $GCP_HOST/$PROJECT/storefront-accounts:gke-2.2.0
docker push $GCP_HOST/$PROJECT/storefront-orders:gke-2.2.0
docker push $GCP_HOST/$PROJECT/storefront-fulfillment:gke-2.2.1

gcloud container images list --repository $GCP_HOST/$PROJECT
