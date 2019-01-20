#!/bin/bash
#
# author: Gary A. Stafford
# site: https://programmaticponderings.com
# license: MIT License
# purpose: Deploy Kubernetes/Istio resources

# Constants - CHANGE ME!
readonly CERT_PATH=~/Documents/Articles/gke-kafka/sslforfree_wildcard
readonly NAMESPACES=( 'dev' 'test' 'uat' )

# kubectl delete -n istio-system secret istio-ingressgateway-certs
# kubectl delete -n istio-system secret istio-ingressgateway-ca-certs

# Kubernetes Secret to hold the server’s certificate and private key
kubectl create -n istio-system secret tls istio-ingressgateway-certs \
  --key $CERT_PATH/private.key --cert $CERT_PATH/certificate.crt

# kubectl create -n istio-system secret generic istio-ingressgateway-ca-certs \
#   --from-file $CERT_PATH/ca_bundle.crt

# Istio Gateway and three ServiceEntry resources
kubectl apply -f ./resources/other/istio-gateway.yaml

# End-user auth applied per environment
kubectl apply -f ./resources/other/auth-policy-dev.yaml
kubectl apply -f ./resources/other/auth-policy-test.yaml
kubectl apply -f ./resources/other/auth-policy-uat.yaml
# kubectl apply -f ./resources/other/auth-policy-ingressgateway.yaml

# Loop through each non-prod Namespace (environment)
# Re-use same resources (incld. credentials) for all environments, just for the demo
for namespace in ${NAMESPACES[@]}; do
  kubectl apply -n $namespace -f ./resources/config/confluent-cloud-kafka-configmap.yaml
  kubectl apply -n $namespace -f ../../storefront-secrets/mongodb-atlas-secret.yaml
  kubectl apply -n $namespace -f ../../storefront-secrets/confluent-cloud-kafka-secret.yaml

  kubectl apply -n $namespace -f ../../storefront-secrets/external-mesh-mongodb-atlas.yaml
  kubectl apply -n $namespace -f ../../storefront-secrets/external-mesh-confluent-cloud.yaml

  kubectl apply -n $namespace -f ./resources/services/accounts.yaml
  kubectl apply -n $namespace -f ./resources/services/fulfillment.yaml
  kubectl apply -n $namespace -f ./resources/services/orders.yaml

  # kubectl scale --replicas=3 -n $namespace deployment.extensions/accounts
  # kubectl scale --replicas=3 -n $namespace deployment.extensions/fulfillment
  # kubectl scale --replicas=3 -n $namespace deployment.extensions/orders
done
