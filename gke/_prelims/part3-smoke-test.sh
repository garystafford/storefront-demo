#!/bin/bash

# part 3: smoke test deployed application
# https://istio.io/docs/guides/bookinfo.html

export INGRESS_HOST=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].port}')
export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].port}')

# export GATEWAY_URL="$(minikube ip):"\
# "$(kubectl get svc istio-ingress -n istio-system -o 'jsonpath={.spec.ports[0].nodePort}')"
# echo $GATEWAY_URL
#
# curl $GATEWAY_URL/v2/actuator/health && echo
