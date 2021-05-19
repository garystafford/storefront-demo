## Deploy to Minikube

```bash
# install minikube
# https://istio.io/latest/docs/setup/install/istioctl/
brew install minikube

# create cluster
minikube start --cpus 2 --memory 3072
minikube status

# deploy to local minikube dev environment
kubectl config current-context

eval $(minikube docker-env) && docker ps

# Install Istio 1.9.4 with Istioctl
echo $ISTIO_HOME # /Applications/Istio/istio-1.9.4

# https://istio.io/latest/docs/setup/install/istioctl/
istioctl profile list
istioctl profile dump demo
#yes | istioctl install --set profile=demo
istioctl install --set profile=default -y


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
kubectl apply -f ./minikube/resources/orders.yaml -n dev
kubectl apply -f ./minikube/resources/fulfillment.yaml -n dev

kubectl apply -f ./minikube/resources/destination_rules.yaml -n dev
kubectl apply -f ./minikube/resources/istio-gateway.yaml -n dev #istio-system

# prometheus required by kiali
kubectl apply -f $ISTIO_HOME/samples/addons/prometheus.yaml
kubectl apply -f $ISTIO_HOME/samples/addons/kiali.yaml
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

## Reference

- <https://minikube.sigs.k8s.io/docs/handbook/accessing/>

