# Kafka Docker

_Cloned from wurstmeister/kafka_  
See the source at: <http://wurstmeister.github.io/kafka-docker/>

## Goal

Spins up Kafka, Zookeeper, Kafka Manager, MongoDB, Zuul, Eureka Server, and the three Storefront microservices, for use with a new post I am writing, 'Using Eventual Consistency and Spring for Kafka, to Manage a Microservice-based Distributed Data Model: Part 1 of 2'.

Docker Compose file exposes ports so I can attach to containerized services from within my local Development environment.

## Usage

```bash
docker-compose -f docker-compose-local.yml up -d

# or for on-going development, I prefer
docker-compose -f docker-compose-local.yml up -d \
  --force-recreate --remove-orphans
```

## Results

```text
CONTAINER ID        IMAGE                                        COMMAND                  CREATED             STATUS              PORTS                                                NAMES
edac9048b253        garystafford/storefront-accounts:latest      "java -jar -Djava.se…"   25 minutes ago      Up 25 minutes       0.0.0.0:8085->8080/tcp                               kafka-docker_accounts_1
a3dabc959d00        garystafford/storefront-orders:latest        "java -jar -Djava.se…"   25 minutes ago      Up 25 minutes       0.0.0.0:8090->8080/tcp                               kafka-docker_orders_1
fe2d085a909c        garystafford/storefront-fulfillment:latest   "java -jar -Djava.se…"   25 minutes ago      Up 25 minutes       0.0.0.0:8095->8080/tcp                               kafka-docker_fulfillment_1
7ba049a1a646        65b8b799f3af                                 "java -jar -Djava.se…"   26 minutes ago      Up 26 minutes       0.0.0.0:8080->8080/tcp, 8761/tcp                     kafka-docker_zuul_1
b37596d66b1f        hlebalbau/kafka-manager:latest               "/kafka-manager/bin/…"   26 minutes ago      Up 26 minutes       0.0.0.0:9000->9000/tcp                               kafka-docker_kafka_manager_1
a1f1cda0382b        wurstmeister/kafka:latest                    "start-kafka.sh"         26 minutes ago      Up 26 minutes       0.0.0.0:9092->9092/tcp                               kafka-docker_kafka_1
5fc949fd8383        wurstmeister/zookeeper:latest                "/bin/sh -c '/usr/sb…"   26 minutes ago      Up 26 minutes       22/tcp, 2888/tcp, 3888/tcp, 0.0.0.0:2181->2181/tcp   kafka-docker_zookeeper_1
98e7e385e365        mongo:latest                                 "docker-entrypoint.s…"   27 minutes ago      Up 27 minutes       0.0.0.0:27017->27017/tcp                             kafka-docker_mongo_1
04004191fd61        873ce10b973e                                 "java -jar -Djava.se…"   3 hours ago         Up 3 hours          0.0.0.0:8761->8761/tcp                               kafka-docker_eureka_1```
