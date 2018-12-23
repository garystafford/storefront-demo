#!/bin/bash

# part 1: create local dev environment on gke

export NAMESPACE="dev"
export PROJECT="dataproc-demo-224523"
export CLUSTER="istio-kafka-demo"
export ZONE="us-east1-b"

time \
  gcloud beta container \
  --project $PROJECT clusters create $CLUSTER \
  --zone $ZONE \
  --username "admin" \
  --cluster-version "1.11.5-gke.4" \
  --machine-type "n1-standard-1" \
  --image-type "COS" \
  --disk-type "pd-standard" \
  --disk-size "100" \
  --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" \
  --num-nodes "2" \
  --enable-cloud-logging \
  --enable-cloud-monitoring \
  --no-enable-ip-alias \
  --network "projects/dataproc-demo-224523/global/networks/default" \
  --subnetwork "projects/dataproc-demo-224523/regions/us-east1/subnetworks/default" \
  --addons "HorizontalPodAutoscaling,HttpLoadBalancing,Istio" \
  --istio-config "auth=MTLS_PERMISSIVE" \
  --enable-autoupgrade \
  --enable-autorepair \
  --issue-client-certificate

gcloud container clusters get-credentials $CLUSTER \
  --zone $ZONE \
  --project $PROJECT

kubectl config current-context

# gcloud container clusters describe $CLUSTER \
#   --zone $ZONE | \
#   grep -e clusterIpv4Cidr -e servicesIpv4Cidr

# create dev namespace
kubectl apply -f ./resources/other/namespace-$NAMESPACE.yaml

# enable automatic instio injection
# kubectl label namespace $NAMESPACE istio-injection=enabled
