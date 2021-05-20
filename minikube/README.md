# Deploy to Minikube

```bash
# install minikube
brew install minikube

# create cluster
minikube --cpus 3 --memory 4g start
minikube status

# deploy to local minikube dev environment
kubectl config current-context

eval $(minikube docker-env) && docker ps

# Install Istio Istioctl
# https://istio.io/latest/docs/setup/install/istioctl/
echo $ISTIO_HOME # /Applications/Istio/istio-1.10.0

# https://istio.io/latest/docs/setup/install/istioctl/
istioctl profile list
# istioctl profile dump demo
istioctl install --set profile=default -y

# new tab
# kubernetes dashboard
minikube dashboard

# new tab
minikube tunnel

kubectl apply -f ./minikube/resources/namespace.yaml
kubectl label namespace dev istio-injection=enabled

kubectl apply -f ./minikube/resources/zookeeper.yaml -n dev
kubectl apply -f ./minikube/resources/mongodb.yaml -n dev
# wait until running
sleep 120
kubectl apply -f ./minikube/resources/kafka.yaml -n dev
# wait until running
sleep 180
kubectl apply -f ./minikube/resources/cmak.yaml -n dev
kubectl apply -f ./minikube/resources/mongo-express.yaml -n dev

# minikube service --url mongo-express -n dev
# minikube service --url cmak -n dev

# wait until running
kubectl apply -f ./minikube/resources/accounts.yaml -n dev
kubectl apply -f ./minikube/resources/orders.yaml -n dev
kubectl apply -f ./minikube/resources/fulfillment.yaml -n dev

kubectl apply -f ./minikube/resources/destination_rules.yaml -n dev
kubectl apply -f ./minikube/resources/istio-gateway.yaml -n dev #istio-system

kubectl get svc istio-ingressgateway -n istio-system

# prometheus required by kiali
kubectl apply -f $ISTIO_HOME/samples/addons/prometheus.yaml
kubectl apply -f $ISTIO_HOME/samples/addons/kiali.yaml


# new tab
istioctl dashboard kiali
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

## Yolean/kubernetes-kafka

```text
kubectl delete -f ./minikube/resources/kafka.yaml -n dev
kubectl delete -f ./minikube/resources/zookeeper.yaml -n dev

# https://github.com/Yolean/kubernetes-kafka
git clone https://github.com/Yolean/kubernetes-kafka.git && cd kubernetes-kafka
kubectl apply -f 00-namespace.yml
kubectl apply -k github.com/Yolean/kubernetes-kafka/variants/dev-small/?ref=v6.0.3

kubectl apply -f rbac-namespace-default
kubectl apply -f zookeeper
kubectl apply -f kafka
```

## Strimzi Quick Start guide (0.23.0)

```shell
# https://strimzi.io/docs/operators/latest/quickstart.html
# https://github.com/strimzi/strimzi-kafka-operator/releases/download/0.23.0/strimzi-0.23.0.zip
kubectl create ns kafka
sed -i '' 's/namespace: .*/namespace: kafka/' install/cluster-operator/*RoleBinding*.yaml
kubectl create ns storefront-kafka-project
nano install/cluster-operator/060-Deployment-strimzi-cluster-operator.yaml
        #   env:
        #     - name: STRIMZI_NAMESPACE
        #       value: storefront-kafka-project
kubectl create -f install/cluster-operator/ -n kafka
kubectl create -f install/cluster-operator/020-RoleBinding-strimzi-cluster-operator.yaml -n storefront-kafka-project
kubectl create -f install/cluster-operator/032-RoleBinding-strimzi-cluster-operator-topic-operator-delegation.yaml -n storefront-kafka-project
kubectl create -f install/cluster-operator/031-RoleBinding-strimzi-cluster-operator-entity-operator-delegation.yaml -n storefront-kafka-project
# run cat << EOF | kubectl create -n storefront-kafka-project -f -... command
kubectl wait kafka/kafka-cluster --for=condition=Ready --timeout=300s -n storefront-kafka-project
# run three topic commands
kubectl get service kafka-cluster-kafka-external-bootstrap -n storefront-kafka-project -o=jsonpath='{.spec.ports[0].nodePort}{"\n"}'
# 31542
kubectl get nodes --output=jsonpath='{range .items[*]}{.status.addresses[?(@.type=="InternalIP")].address}{"\n"}{end}'
192.168.49.2
```

## Zoo Entrence

```shell
# https://github.com/strimzi/strimzi-kafka-operator/issues/1337
git clone https://github.com/scholzj/zoo-entrance.git && cd zoo-entrance
nano deploy.yaml
# change my-cluster to kafka-cluster
kubectl apply -f deploy.yaml -n storefront-kafka-project
```

## Reference

- <https://minikube.sigs.k8s.io/docs/handbook/accessing/>

