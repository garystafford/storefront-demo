# Deploy to Minikube

Assume Istio is downloaded and $`ISTIO_HOME` is added to `$PATH`.

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
minikube tunnel

kubectl get svc istio-ingressgateway -n istio-system

# new tab
minikube dashboard

kubectl apply -f ./minikube/resources/namespaces.yaml
kubectl label namespace dev istio-injection=enabled

kubectl apply -f ./minikube/resources/mongodb.yaml -n mongo
sleep 60
kubectl apply -f ./minikube/resources/mongo-express.yaml -n mongo

# new tab
minikube service --url mongo-express -n mongo

# install Strimzi Kafka (see below)
# install Zoo Entrance (see below)

kubectl apply -f ./minikube/resources/cmak.yaml -n storefront-kafka-project
# new tab
minikube service --url cmak -n storefront-kafka-project

# wait until running
kubectl apply -f ./minikube/resources/accounts.yaml -n dev
kubectl apply -f ./minikube/resources/orders.yaml -n dev
kubectl apply -f ./minikube/resources/fulfillment.yaml -n dev

kubectl apply -f ./minikube/resources/destination_rules.yaml -n dev
kubectl apply -f ./minikube/resources/istio-gateway.yaml -n dev

# prometheus required by kiali
kubectl apply -f $ISTIO_HOME/samples/addons/prometheus.yaml
kubectl apply -f $ISTIO_HOME/samples/addons/grafana.yaml
kubectl apply -f $ISTIO_HOME/samples/addons/kiali.yaml

# new tab
istioctl dashboard kiali
istioctl dashboard prometheus
istioctl dashboard grafana

```

## Misc. Commands

```bash
brew cask upgrade minikube
minikube version
kubectl get nodes
kubectl describe node
kubectl get namespaces
kubectl get services -n dev
```

## Yolean/kubernetes-kafka (not used)

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
# assuming 0.23.0 is latest version available
curl -L -O https://github.com/strimzi/strimzi-kafka-operator/releases/download/0.23.0/strimzi-0.23.0.zip
unzip strimzi-0.23.0.zip
cd strimzi-0.23.0
sed -i '' 's/namespace: .*/namespace: kafka/' install/cluster-operator/*RoleBinding*.yaml
# manually change STRIMZI_NAMESPACE value to storefront-kafka-project
nano install/cluster-operator/060-Deployment-strimzi-cluster-operator.yaml
kubectl create -f install/cluster-operator/ -n kafka
kubectl create -f install/cluster-operator/020-RoleBinding-strimzi-cluster-operator.yaml -n storefront-kafka-project
kubectl create -f install/cluster-operator/032-RoleBinding-strimzi-cluster-operator-topic-operator-delegation.yaml -n storefront-kafka-project
kubectl create -f install/cluster-operator/031-RoleBinding-strimzi-cluster-operator-entity-operator-delegation.yaml -n storefront-kafka-project
kubectl apply -f ../storefront-demo/minikube/resources/strimzi-kafka-cluster.yaml -n storefront-kafka-project
kubectl wait kafka/kafka-cluster --for=condition=Ready --timeout=300s -n storefront-kafka-project
kubectl apply -f ../storefront-demo/minikube/resources/strimzi-kafka-topics.yaml -n storefront-kafka-project
```

## Zoo Entrance

You can't access Strimzi's Zookeeper from CMAK directly (this is intentional). Use Zoo Entrance as a proxy for CMAK to Zookeeper.

```shell
# https://github.com/strimzi/strimzi-kafka-operator/issues/1337
git clone https://github.com/scholzj/zoo-entrance.git && cd zoo-entrance
# nano deploy.yaml
# change my-cluster to kafka-cluster
sed -i '' 's/my-cluster/kafka-cluster/' deploy.yaml
kubectl apply -f deploy.yaml -n storefront-kafka-project
```

## Reference

- <https://minikube.sigs.k8s.io/docs/handbook/accessing/>