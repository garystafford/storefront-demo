# Kafka Docker

_Cloned from wurstmeister/kafka_  
See the source at: <http://wurstmeister.github.io/kafka-docker/>

## Goal

Spins up Docker containers for Kafka, Zookeeper, Kafka Manager, MongoDB, Zuul, Eureka Server, and the three Storefront microservices, for use with a new post I am writing, 'Using Eventual Consistency and Spring for Kafka, to Manage a Microservice-based Distributed Data Model: Part 1 of 2'. Note there is no persistent storage backing Kafka or MongoDB.

In the Docker Compose file, you can chose uncomment the Kafka and MongoDB ports to expose them for local development.

## Usage

```bash
docker-compose up -d

# or for on-going development, I prefer
docker-compose up -d --force-recreate --remove-orphans
docker-compose rm
```

## Results

```text
CONTAINER ID        IMAGE                                        COMMAND                  CREATED             STATUS              PORTS                                                NAMES
effc6503860f        hlebalbau/kafka-manager:latest               "/kafka-manager/bin/…"   41 seconds ago      Up 37 seconds       0.0.0.0:9000->9000/tcp                               storefront-kafka-docker_kafka_manager_1
1d18e19319d5        garystafford/storefront-orders:latest        "java -jar -Djava.se…"   41 seconds ago      Up 37 seconds       0.0.0.0:8090->8080/tcp                               storefront-kafka-docker_orders_1
f860d8198bbd        garystafford/storefront-accounts:latest      "java -jar -Djava.se…"   41 seconds ago      Up 37 seconds       0.0.0.0:8085->8080/tcp                               storefront-kafka-docker_accounts_1
1d508aeffe7a        garystafford/storefront-fulfillment:latest   "java -jar -Djava.se…"   41 seconds ago      Up 37 seconds       0.0.0.0:8095->8080/tcp                               storefront-kafka-docker_fulfillment_1
e2cd48d96911        garystafford/storefront-zuul:latest          "java -jar -Djava.se…"   41 seconds ago      Up 37 seconds       0.0.0.0:8080->8080/tcp, 8761/tcp                     storefront-kafka-docker_zuul_1
053b5e5ef422        wurstmeister/kafka:latest                    "start-kafka.sh"         42 seconds ago      Up 40 seconds       0.0.0.0:9092->9092/tcp                               storefront-kafka-docker_kafka_1
a1089ad5b41c        mongo:latest                                 "docker-entrypoint.s…"   43 seconds ago      Up 41 seconds       0.0.0.0:27017->27017/tcp                             storefront-kafka-docker_mongo_1
e71d0cb034b7        garystafford/storefront-eureka:latest        "java -jar -Djava.se…"   43 seconds ago      Up 41 seconds       0.0.0.0:8761->8761/tcp                               storefront-kafka-docker_eureka_1
8ad4a1cffe9e        wurstmeister/zookeeper:latest                "/bin/sh -c '/usr/sb…"   43 seconds ago      Up 41 seconds       22/tcp, 2888/tcp, 3888/tcp, 0.0.0.0:2181->2181/tcp   storefront-kafka-docker_zookeeper_1
```
