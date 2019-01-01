#!/bin/bash

# part 2: deploy resources to dev namespace

export NAMESPACE="dev"
export PROJECT="gke-confluent-atlas"
export CLUSTER="storefront-api"
export REGION="us-central1"
export ZONE="us-central1-a"

kubectl apply -f ./resources/other/istio-gateway.yaml
kubectl apply -f ./resources/other/mongodb-atlas-external-mesh.yaml
kubectl apply -f ./resources/other/confluent-cloud-external-mesh.yaml

kubectl apply -n $NAMESPACE -f ./resources/config/confluent-cloud-kafka-configmap.yaml
kubectl apply -n $NAMESPACE -f ./resources/config/mongodb-atlas-secret.yaml
kubectl apply -n $NAMESPACE -f ./resources/config/confluent-cloud-kafka-secret.yaml

kubectl apply -n $NAMESPACE -f ./resources/services/accounts.yaml
kubectl apply -n $NAMESPACE -f ./resources/services/fulfillment.yaml
kubectl apply -n $NAMESPACE -f ./resources/services/orders.yaml
