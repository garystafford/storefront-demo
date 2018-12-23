time \
  helm install --name mongodb-release \
    --namespace dev \
    --set mongodbRootPassword=storefront-root-password,mongodbUsername=storefront-user,mongodbPassword=storefront-password,mongodbDatabase=accounts \
    stable/mongodb

NAME:   mongodb-release
E1219 19:17:46.421945   27396 portforward.go:303] error copying from remote stream to local connection: readfrom tcp4 127.0.0.1:52730->127.0.0.1:52733: write tcp4 127.0.0.1:52730->127.0.0.1:52733: write: broken pipe
LAST DEPLOYED: Wed Dec 19 19:17:45 2018
NAMESPACE: dev
STATUS: DEPLOYED

RESOURCES:
==> v1/Secret
NAME             TYPE    DATA  AGE
mongodb-release  Opaque  2     1s

==> v1/PersistentVolumeClaim
NAME             STATUS   VOLUME    CAPACITY  ACCESS MODES  STORAGECLASS  AGE
mongodb-release  Pending  standard  1s

==> v1/Service
NAME             TYPE       CLUSTER-IP    EXTERNAL-IP  PORT(S)    AGE
mongodb-release  ClusterIP  10.47.246.50  <none>       27017/TCP  1s

==> v1beta1/Deployment
NAME             DESIRED  CURRENT  UP-TO-DATE  AVAILABLE  AGE
mongodb-release  1        1        1           0          0s

==> v1/Pod(related)
NAME                              READY  STATUS   RESTARTS  AGE
mongodb-release-745d696745-pfc8n  0/1    Pending  0         0s


NOTES:


** Please be patient while the chart is being deployed **

MongoDB can be accessed via port 27017 on the following DNS name from within your cluster:

    mongodb-release.dev.svc.cluster.local

To get the root password run:

    export MONGODB_ROOT_PASSWORD=$(kubectl get secret --namespace dev mongodb-release -o jsonpath="{.data.mongodb-root-password}" | base64 --decode)

To get the password for "storefront-user" run:

    export MONGODB_PASSWORD=$(kubectl get secret --namespace dev mongodb-release -o jsonpath="{.data.mongodb-password}" | base64 --decode)

To connect to your database run the following command:

    kubectl run --namespace dev mongodb-release-client --rm --tty -i --restart='Never' --image bitnami/mongodb --command -- mongo admin --host mongodb-release --authenticationDatabase admin -u root -p $MONGODB_ROOT_PASSWORD

To connect to your database from outside the cluster execute the following commands:

    kubectl port-forward --namespace dev svc/mongodb-release 27017:27017 &
    mongo --host 127.0.0.1 --authenticationDatabase admin -p $MONGODB_ROOT_PASSWORD

helm install --name mongodb-release --namespace dev --set  stable/mongodb  0.83s user 0.13s system 24% cpu 3.981 total
