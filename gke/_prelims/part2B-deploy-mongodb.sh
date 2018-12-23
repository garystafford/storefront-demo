#!/bin/bash

# part 2: deploy resources

export NAMESPACE=dev

# # ingress
# kubectl apply -f ./resources/other/ingress-$NAMESPACE.yaml

# helm install mongodb
# https://docs.helm.sh/using_helm/#role-based-access-control
# kubectl create -f ./resources/other/tiller-cluster-admin-service-account.yaml
#
# helm init --service-account tiller --upgrade
#
# helm install --name mongodb-release \
#   --namespace $NAMESPACE \
#   --set mongodbRootPassword=storefront-root-password \
#   --set mongodbUsername=storefront-user \
#   --set mongodbPassword=storefront-password \
#   --set mongodbDatabase=accounts \
#   --set mongodbEnableIPv6=false \
#   stable/mongodb
#
# export MONGODB_ROOT_PASSWORD=$(kubectl get secret --namespace dev mongodb-release -o jsonpath="{.data.mongodb-root-password}" | base64 --decode)
# export MONGODB_PASSWORD=$(kubectl get secret --namespace dev mongodb-release -o jsonpath="{.data.mongodb-password}" | base64 --decode)

# kubectl apply -n $NAMESPACE -f ./resources/mongodb/mongodb-deployment.yaml
# kubectl apply -n $NAMESPACE -f ./resources/mongodb/mongodb-service.yaml

# kubectl apply -n $NAMESPACE -f ./resources/mongodb/mongo-express-deployment.yaml
# kubectl apply -n $NAMESPACE -f ./resources/mongodb/mongo-express-service.yaml
