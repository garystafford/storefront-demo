#!/bin/bash
#
# author: Gary A. Stafford
# site: https://programmaticponderings.com
# license: MIT License
# purpose: Create non-prod Kubernetes cluster on GKE

# Constants - CHANGE ME!
readonly NAMESPACE='dev'
readonly PROJECT='gke-confluent-atlas'
readonly CLUSTER='storefront-api'
readonly REGION='us-central1'
readonly ZONE='us-central1-a'

# Create GKE cluster (time in foreground)
time \
  gcloud beta container \
  --project $PROJECT clusters create $CLUSTER \
  --zone $ZONE \
  --username "admin" \
  --cluster-version "1.11.5-gke.5" \
  --machine-type "n1-standard-2" \
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
  --istio-config auth=MTLS_PERMISSIVE \
  --issue-client-certificate \
  --metadata disable-legacy-endpoints=true \
  --enable-autoupgrade \
  --enable-autorepair

# Get cluster creds
gcloud container clusters get-credentials $CLUSTER \
  --zone $ZONE --project $PROJECT

kubectl config current-context

# Create dev Namespace
kubectl apply -f ./resources/other/namespaces.yaml

# Enable Istio automatic sidecar injection in Dev Namespace
kubectl label namespace $NAMESPACE istio-injection=enabled
