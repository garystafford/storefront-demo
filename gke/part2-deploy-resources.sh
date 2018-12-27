#!/bin/bash

# part 2: deploy resources to dev namespace

export NAMESPACE="dev"
export PROJECT="gke-confluent-atlas"
export CLUSTER="storefront-api"
export REGION="us-central1"
export ZONE="us-central1-a"

# export INGRESS_HOST=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
# export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].port}')
# export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].port}')

# export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}')
# export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].nodePort}')

# gcloud compute firewall-rules create allow-gateway-http --allow tcp:$INGRESS_PORT
# gcloud compute firewall-rules create allow-gateway-https --allow tcp:$SECURE_INGRESS_PORT

kubectl apply ./resources/other/istio-gateway.yaml

kubectl apply -n $NAMESPACE -f ./resources/config/confluent-cloud-kafka-configmap.yaml
kubectl apply -n $NAMESPACE -f ../../storefront-secrets/mongodb-atlas-secret.yaml
kubectl apply -n $NAMESPACE -f ../../storefront-secrets/confluent-cloud-kafka-secret.yaml

# IP_RANGES="10.44.0.0/14,10.47.240.0/20"
#
# istioctl kube-inject –kubeconfig "~/.kube/config" \
#   -f ./resources/services/accounts.yaml \
#   --injectConfigFile inject-config.yaml \
#   --meshConfigFile mesh-config.yaml > \
#   accounts-istio.yaml \
#   && kubectl apply -f accounts-istio.yaml -n dev \
#   && rm accounts-istio.yaml

kubectl apply -n $NAMESPACE -f ./resources/services/accounts.yaml
kubectl apply -n $NAMESPACE -f ./resources/services/fulfillment.yaml
kubectl apply -n $NAMESPACE -f ./resources/services/orders.yaml
