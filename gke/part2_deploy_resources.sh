#!/bin/bash
#
# Part 2: Deploy resources

# Constants - CHANGE ME!
readonly CERT_PATH=~/Documents/Articles/gke-kafka/sslforfree_wildcard
readonly NAMESPACES=( 'dev' 'test' 'uat' )

# kubectl delete -n istio-system secret istio-ingressgateway-certs
# kubectl delete -n istio-system secret istio-ingressgateway-ca-certs

# Require HTTPS for all access
kubectl create -n istio-system secret tls istio-ingressgateway-certs \
  --key $CERT_PATH/private.key --cert $CERT_PATH/certificate.crt

kubectl create -n istio-system secret generic istio-ingressgateway-ca-certs \
  --from-file $CERT_PATH/ca_bundle.crt

# Istio Gateway and three ServiceEntry resources
kubectl apply -f ./resources/other/istio-gateway.yaml

# Auth applied per environment (client-facing)
kubectl apply -f ./resources/other/dev-auth-policy.yaml
kubectl apply -f ./resources/other/test-auth-policy.yaml
kubectl apply -f ./resources/other/uat-auth-policy.yaml
# kubectl apply -f ./resources/other/jwksuri-external-mesh.yaml

# Loop through each non-prod Namespace (environment)
# Re-use same secrets for Demo only
for namespace in ${NAMESPACES[@]}; do
  kubectl apply -n $namespace -f ./resources/config/confluent-cloud-kafka-configmap.yaml
  kubectl apply -n $namespace -f ../../storefront-secrets/mongodb-atlas-secret.yaml
  kubectl apply -n $namespace -f ../../storefront-secrets/confluent-cloud-kafka-secret.yaml

  kubectl apply -n $namespace -f ../../storefront-secrets/mongodb-atlas-external-mesh.yaml
  kubectl apply -n $namespace -f ../../storefront-secrets/confluent-cloud-external-mesh.yaml

  kubectl apply -n $namespace -f ./resources/services/accounts.yaml
  # kubectl apply -n $namespace -f ./resources/services/fulfillment.yaml
  # kubectl apply -n $namespace -f ./resources/services/orders.yaml
done
