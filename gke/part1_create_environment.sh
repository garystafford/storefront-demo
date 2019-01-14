#!/bin/bash
#
# Part 1: Create local Kubernetes cluster on GKE

# Constants - CHANGE ME!
readonly PROJECT='gke-confluent-atlas'
readonly CLUSTER='storefront-api-non-prod'
readonly REGION='us-central1'
readonly ZONE='us-central1-a'
readonly NAMESPACES=( 'dev' 'test' 'uat' )

time gcloud beta container \
  --project $PROJECT clusters create $CLUSTER \
  --zone $ZONE \
  --no-enable-basic-auth \
  --cluster-version "1.11.5-gke.5" \
  --num-nodes "3" \
  --machine-type "n1-standard-1" \
  --image-type "COS" \
  --disk-type "pd-standard" --disk-size "100" \
  --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" \
  --enable-stackdriver-kubernetes \
  --enable-ip-alias \
  --network "projects/${PROJECT}/global/networks/default" \
  --subnetwork "projects/${PROJECT}/regions/${REGION}/subnetworks/default" \
  --default-max-pods-per-node "110" \
  --addons HorizontalPodAutoscaling,HttpLoadBalancing,Istio \
  --istio-config auth=MTLS_STRICT \
  --metadata disable-legacy-endpoints=true \
  --enable-autoupgrade --enable-autorepair

gcloud container clusters get-credentials $CLUSTER \
  --zone $ZONE --project $PROJECT

kubectl config current-context

# Create Namespaces
kubectl apply -f ./resources/other/namespaces.yaml

# Enable automatic Istio sidecar injection
for namespace in ${NAMESPACES[@]}; do
	kubectl label namespace $namespace istio-injection=enabled
done
# kubectl label namespace dev istio-injection=disabled --overwrite
