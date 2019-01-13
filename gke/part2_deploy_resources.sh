#!/bin/bash
#
# Part 2: Deploy resources

# Constants - CHANGE ME!
readonly NAMESPACE='dev'
readonly PROJECT='gke-confluent-atlas'
readonly CLUSTER='storefront-api'
readonly REGION='us-central1'
readonly ZONE='us-central1-a'

kubectl apply -f ./resources/other/istio-gateway.yaml

kubectl apply -n $NAMESPACE -f ./resources/other/mongodb-atlas-external-mesh.yaml
kubectl apply -n $NAMESPACE -f ./resources/other/confluent-cloud-external-mesh.yaml

kubectl apply -n $NAMESPACE -f ./resources/config/confluent-cloud-kafka-configmap.yaml
kubectl apply -f ./resources/config/mongodb-atlas-secret.yaml
kubectl apply -f ./resources/config/confluent-cloud-kafka-secret.yaml

kubectl apply -n $NAMESPACE -f ./resources/services/accounts.yaml
kubectl apply -n $NAMESPACE -f ./resources/services/fulfillment.yaml
kubectl apply -n $NAMESPACE -f ./resources/services/orders.yaml
