# Minikube

Before deploying to GKE, you should always test your application, as well as your Kubernetes resource files (secrets, deployments, services, namespaces, routerules, etc.) on minikube.

## Deploy to Minikube

```bash
# install minikube
# https://istio.io/latest/docs/setup/install/istioctl/
brew install minikube

# create cluster
minikube start
minikube status

# Install Istio 1.9.4 with Istioctl
# https://istio.io/latest/docs/setup/install/istioctl/
istioctl profile list
istioctl profile dump demo
#yes | istioctl install --set profile=demo
istioctl install --set profile=default -y

# deploy to local minikube dev environment
kubectl config current-context

# new tab
minikube tunnel

kubectl apply -f ./minikube/resources/namespace.yaml
kubectl label namespace dev istio-injection=enabled

kubectl apply -f ./minikube/resources/mongodb.yaml -n dev
kubectl apply -f ./minikube/resources/mongo-express.yaml -n dev
kubectl apply -f ./minikube/resources/zookeeper.yaml -n dev
kubectl apply -f ./minikube/resources/kafka.yaml -n dev
kubectl apply -f ./minikube/resources/cmak.yaml -n dev

# minikube service --url mongo-express -n dev
# minikube service --url cmak -n dev

kubectl apply -f ./minikube/resources/accounts.yaml -n dev

kubectl apply -f ./minikube/resources/destination_rules.yaml -n dev
kubectl apply -f ./minikube/resources/istio-gateway.yaml -n dev #istio-system

kubectl apply -f $ISTIO_HOME/samples/addons/kiali.yaml
kubectl apply -f $ISTIO_HOME/samples/addons/prometheus.yaml
istioctl dashboard kiali

# kubernetes dashboard
minikube dashboard
```

## Misc. Commands

```bash
brew cask upgrade minikube
minikube version
eval $(minikube docker-env) && docker ps
kubectl config use-context minikube
kubectl get nodes
kubectl get namespaces
kubectl get services -n dev
kubectl describe node
```
