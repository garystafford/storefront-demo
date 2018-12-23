# Kafka Docker

_Cloned from wurstmeister/kafka_  
See the source at: <http://wurstmeister.github.io/kafka-docker/>

## Goal

Spins up a Docker Swarm with a Docker Stack, including containers for Kafka, Zookeeper, Kafka Manager, MongoDB, Mongo Express, Zuul, Eureka Server, and the three Storefront microservices. For use with my two-part post, [Using Eventual Consistency and Spring for Kafka to Manage a Distributed Data Model](https://wp.me/p1RD28-5SF). Note there is no persistent storage backing Kafka or MongoDB.

In the Docker Compose file, you can chose uncomment the Kafka and MongoDB ports to expose them for local development.

-   Zuul Endpoints: <http://localhost:8080/actuator/mappings>
-   Zuul Routes: <http://localhost:8080/actuator/routes>
-   Eureka UI: <http://localhost:8761>
-   Kafka Manager UI: <http://localhost:9000>
-   Mongo Express UI: <http://localhost:8081>

## Usage

Build Docker Swarm and deploy Docker Stack.

```bash
docker swarm init
sh ./stack_deploy_local.sh
```

Delete (3) MongoDB databases, (3) Kafka topics, create sample data by hitting Zuul API Gateway endpoints, and return MongoDB documents as verification.

```bash
python3 ./refresh.py
```

## Results

```text
$ docker stack ls
NAME                SERVICES
storefront          10

$ docker stack services storefront

ID                  NAME                       MODE                REPLICAS            IMAGE                                        PORTS
ID                  NAME                       MODE                REPLICAS            IMAGE                                        PORTS
2b8h3jhbnqfy        storefront_mongo_express   replicated          1/1                 mongo-express:latest                         *:8081->8081/tcp
5rwt5ayi20md        storefront_accounts        replicated          1/1                 garystafford/storefront-accounts:latest
6d3uxc08s4ko        storefront_mongo           replicated          1/1                 mongo:latest                                 *:27017->27017/tcp
ezkh59y3kncd        storefront_kafka_manager   replicated          1/1                 hlebalbau/kafka-manager:latest               *:9000->9000/tcp
gzz4o5q1v7dr        storefront_fulfillment     replicated          1/1                 garystafford/storefront-fulfillment:latest
jk2twiamz474        storefront_zuul            replicated          1/1                 garystafford/storefront-zuul:latest          *:8080->8080/tcp
nx23d9aef15o        storefront_zookeeper       replicated          1/1                 wurstmeister/zookeeper:latest                *:2181->2181/tcp
qggjcswrfv6m        storefront_eureka          replicated          1/1                 garystafford/storefront-eureka:latest        *:8761->8761/tcp
ty4u7r09org5        storefront_kafka           replicated          1/1                 wurstmeister/kafka:latest                    *:9092->9092/tcp
vn1as2p93jrf        storefront_orders          replicated          1/1                 garystafford/storefront-orders:latest

$ docker container ls

CONTAINER ID        IMAGE                                        COMMAND                  CREATED              STATUS              PORTS                                  NAMES
749199f2c84a        mongo-express:latest                         "tini -- node app"       38 seconds ago       Up 36 seconds       8081/tcp                               storefront_mongo_express.1.arjli02nc06p9901y47hpevfl
814b801940ea        wurstmeister/kafka:latest                    "start-kafka.sh"         About a minute ago   Up About a minute                                          storefront_kafka.1.q8d4jw0bcbdmcjrhvjt35p4hv
aea969916f7e        garystafford/storefront-eureka:latest        "java -jar -Djava.se…"   4 hours ago          Up 4 hours          8761/tcp                               storefront_eureka.1.r0ag0rtf5dgxjkipcbgy4phdk
894d57522cf5        garystafford/storefront-zuul:latest          "java -jar -Djava.se…"   4 hours ago          Up 4 hours          8761/tcp                               storefront_zuul.1.vaw0ot7l7yktke2e4skf1dmg2
b650d357d787        hlebalbau/kafka-manager:latest               "/kafka-manager/bin/…"   4 hours ago          Up 4 hours                                                 storefront_kafka_manager.1.heequi6l9ylxqwos5bx47imh2
a93b12beb396        garystafford/storefront-fulfillment:latest   "java -jar -Djava.se…"   4 hours ago          Up 4 hours          8080/tcp                               storefront_fulfillment.1.u1o4rahz0decqpmokmefx9n8a
af280e77f975        wurstmeister/zookeeper:latest                "/bin/sh -c '/usr/sb…"   4 hours ago          Up 4 hours          22/tcp, 2181/tcp, 2888/tcp, 3888/tcp   storefront_zookeeper.1.xbg8xetfof68l89ex4w155gnw
f2c82d998ac8        garystafford/storefront-accounts:latest      "java -jar -Djava.se…"   4 hours ago          Up 4 hours          8080/tcp                               storefront_accounts.1.vceb6iz8kehkssvni7hplsd0q
aab1d81eb677        garystafford/storefront-orders:latest        "java -jar -Djava.se…"   4 hours ago          Up 4 hours          8080/tcp                               storefront_orders.1.sh4klmcnbilg5t33yqd2uzll4
bb2d8ffebafd        mongo:latest                                 "docker-entrypoint.s…"   4 hours ago          Up 4 hours          27017/tcp                              storefront_mongo.1.tg6oa5t75wv2vow2hpoh6q871
```
