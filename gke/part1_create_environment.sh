#!/bin/bash
#
# Part 1: Create local Kubernetes cluster on GKE

# Constants - CHANGE ME!
readonly PROJECT='gke-confluent-atlas'
readonly CLUSTER='storefront-api-non-prod'
readonly REGION='us-central1'
readonly NAMESPACES=( 'dev' 'test' 'uat' )

# Build a 3-node, single-region, multi-zone GKE cluster
# https://cloud.google.com/kubernetes-engine/docs/how-to/private-clusters
time gcloud beta container \
  --project $PROJECT clusters create $CLUSTER \
  --region $REGION \
  --no-enable-basic-auth \
  --no-issue-client-certificate \
  --cluster-version "1.11.5-gke.5" \
  --machine-type "n1-standard-1" \
  --image-type "COS" \
  --disk-type "pd-standard" \
  --disk-size "100" \
  --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" \
  --num-nodes "1" \
  --enable-stackdriver-kubernetes \
  --enable-ip-alias \
  --enable-private-nodes \
  --enable-master-authorized-networks \
  --master-authorized-networks 72.231.208.107/32 \
  --master-ipv4-cidr "172.16.0.0/28" \
  --network "projects/${PROJECT}/global/networks/default" \
  --subnetwork "projects/${PROJECT}/regions/${REGION}/subnetworks/default" \
  --default-max-pods-per-node "110" \
  --addons HorizontalPodAutoscaling,HttpLoadBalancing,Istio \
  --istio-config auth=MTLS_STRICT \
  --metadata disable-legacy-endpoints=true \
  --enable-autoupgrade \
  --enable-autorepair

gcloud container clusters get-credentials $CLUSTER \
  --region $REGION --project $PROJECT

kubectl config current-context

# Create Namespaces
kubectl apply -f ./resources/other/namespaces.yaml

# Enable automatic Istio sidecar injection
for namespace in ${NAMESPACES[@]}; do
	kubectl label namespace $namespace istio-injection=enabled
done
# kubectl label namespace dev istio-injection=disabled --overwrite
