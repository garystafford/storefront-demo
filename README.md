# Kafka Docker

_Cloned from wurstmeister/kafka_  
See the source at: <http://wurstmeister.github.io/kafka-docker/>

## Goal

Spins up a Docker Stack, including containers for Kafka, Zookeeper, Kafka Manager, MongoDB, Zuul, Eureka Server, and the three Storefront microservices, for use with a new post I am writing, 'Using Eventual Consistency and Spring for Kafka, to Manage a Microservice-based Distributed Data Model: Part 1 of 2'. Note there is no persistent storage backing Kafka or MongoDB.

In the Docker Compose file, you can chose uncomment the Kafka and MongoDB ports to expose them for local development.

## Usage

```bash
docker swarm init
docker stack deploy -c docker-compose.yml storefront
```

## Results
$ docker container ls
```text
CONTAINER ID        IMAGE                                        COMMAND                  CREATED              STATUS              PORTS                                  NAMES
b1739c25ea47        wurstmeister/kafka:latest                    "start-kafka.sh"         About a minute ago   Up About a minute                                          storefront_kafka.1.m9t0j465gcrjifsg3bgma64wc
59a5c4a5a905        garystafford/storefront-fulfillment:latest   "java -jar -Djava.se…"   About a minute ago   Up About a minute   8080/tcp                               storefront_fulfillment.1.iw02ockbyozk21c1fd4ggo96x
0ff04a4c9c44        garystafford/storefront-orders:latest        "java -jar -Djava.se…"   2 minutes ago        Up 2 minutes        8080/tcp                               storefront_orders.1.rf85jp9g9fa8m2ghf21irjhzg
ad17e37cc1ca        garystafford/storefront-accounts:latest      "java -jar -Djava.se…"   6 minutes ago        Up 6 minutes        8080/tcp                               storefront_accounts.1.ug2fbjypzd1tjgv456am0yb96
0f407f17c942        garystafford/storefront-zuul:latest          "java -jar -Djava.se…"   6 minutes ago        Up 6 minutes        8761/tcp                               storefront_zuul.1.sg600g5gfc3v1pvjxv4xjs64z
fefbc0b5cb7f        mongo:latest                                 "docker-entrypoint.s…"   24 minutes ago       Up 24 minutes       27017/tcp                              storefront_mongo.1.it03z2j35zrtdjy3ovvb5vl4z
e624850f76f1        hlebalbau/kafka-manager:latest               "/kafka-manager/bin/…"   25 minutes ago       Up 24 minutes                                              storefront_kafka_manager.1.ix920o999ps9l8r04srv5n5me
6dcd2511a30c        wurstmeister/zookeeper:latest                "/bin/sh -c '/usr/sb…"   25 minutes ago       Up 25 minutes       22/tcp, 2181/tcp, 2888/tcp, 3888/tcp   storefront_zookeeper.1.w5rhoevig0ng85ar3m4dqfv2t
2aaca5fe98a7        garystafford/storefront-eureka:latest        "java -jar -Djava.se…"   26 minutes ago       Up 26 minutes       8761/tcp                               storefront_eureka.1.jvs3h76lo876plbx9sp07vgad
```
