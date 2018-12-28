#!/bin/bash

# part 2: deploy resources to prod namespace

export NAMESPACE="prod"

kubectl apply -n $NAMESPACE -f ./resources/config/confluent-cloud-kafka-configmap.yaml
kubectl apply -n $NAMESPACE -f ../../storefront-secrets/mongodb-atlas-secret.yaml
kubectl apply -n $NAMESPACE -f ../../storefront-secrets/confluent-cloud-kafka-secret.yaml

kubectl apply -n $NAMESPACE -f ./resources/services/accounts.yaml
kubectl apply -n $NAMESPACE -f ./resources/services/fulfillment.yaml
kubectl apply -n $NAMESPACE -f ./resources/services/orders.yaml
