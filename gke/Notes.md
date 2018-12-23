```bash
time \
  gcloud beta container \
    --project "dataproc-demo-224523" clusters create "istio-kafka-demo" \
    --zone "us-east1-b" \
    --username "admin" \
    --cluster-version "1.11.5-gke.4" \
    --machine-type "n1-standard-1" \
    --image-type "COS" \
    --disk-type "pd-standard" \
    --disk-size "100" \
    --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" \
    --num-nodes "2" \
    --enable-cloud-logging \
    --enable-cloud-monitoring \
    --no-enable-ip-alias \
    --network "projects/dataproc-demo-224523/global/networks/default" \
    --subnetwork "projects/dataproc-demo-224523/regions/us-east1/subnetworks/default" \
    --addons HorizontalPodAutoscaling,HttpLoadBalancing,Istio \
    --istio-config auth=MTLS_PERMISSIVE \
    --enable-autoupgrade \
    --enable-autorepair \
    --issue-client-certificate

gcloud container clusters get-credentials istio-kafka-demo \
  --zone us-east1-b \
  --project dataproc-demo-224523

brew install kubernetes-helm

kubectl config current-context

# https://docs.helm.sh/using_helm/#role-based-access-control
kubectl create -f ./resources/tiller-cluster-admin-service-account.yaml
helm init --service-account tiller --upgrade

helm repo update

# https://github.com/helm/charts/tree/master/stable/mongodb
kubectl apply -f ./namespace-dev.yaml

helm install --name mongodb-release \
  --namespace dev \
  --set mongodbRootPassword=storefront-root-password,mongodbUsername=storefront-user,mongodbPassword=storefront-password,mongodbDatabase=accounts \
  stable/mongodb

helm delete --purge mongodb-release

kubectl label namespace dev istio-injection=enabled

kubectl apply -n dev -f ./resources/accounts-deployment.yaml
kubectl apply -n dev -f ./resources/accounts-service.yaml
kubectl apply -n dev -f ./resources/ingress-dev.yaml

kubectl apply -n dev -f ./resources/mongo-express-deployment.yaml
kubectl apply -n dev -f ./resources/mongo-express-service.yaml
kubectl apply -n dev -f ./resources/ingress-dev.yaml

kubectl get svc istio-ingressgateway -n istio-system
kubectl get virtualservices -n dev -o yaml
kubectl get destinationrules -n dev -o yaml
```
