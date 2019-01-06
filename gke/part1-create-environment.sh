#!/bin/bash

# part 1: create local dev environment on gke

export NAMESPACE="dev"
export PROJECT="gke-confluent-atlas"
export CLUSTER="storefront-api"
export REGION="us-central1"
export ZONE="us-central1-a"

time \
  gcloud beta container \
    --project $PROJECT clusters create $CLUSTER \
    --zone $ZONE \
    --no-enable-basic-auth \
    --cluster-version "1.11.5-gke.5" \
    --machine-type "n1-standard-1" \
    --image-type "COS" \
    --disk-type "pd-standard" \
    --disk-size "100" \
    --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" \
    --num-nodes "2" \
    --enable-stackdriver-kubernetes \
    --enable-ip-alias \
    --network "projects/$PROJECT/global/networks/default" \
    --subnetwork "projects/$PROJECT/regions/$REGION/subnetworks/default" \
    --default-max-pods-per-node "110" \
    --addons HorizontalPodAutoscaling,HttpLoadBalancing,Istio \
    --istio-config auth=MTLS_STRICT \
    --metadata disable-legacy-endpoints=true \
    --enable-autoupgrade \
    --enable-autorepair

gcloud container clusters get-credentials $CLUSTER \
  --zone $ZONE \
  --project $PROJECT

kubectl config current-context

# create dev, test, staging namespaces
kubectl apply -f ./resources/other/namespaces.yaml

# enable automatic instio injection
namespaces=( dev test staging )
for ns in "${namespaces[@]}"
do
	kubectl label namespace $ns istio-injection=enabled
done
