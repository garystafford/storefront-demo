# Kafka Docker

_Cloned from wurstmeister/kafka_  
See the source at: <http://wurstmeister.github.io/kafka-docker/>

## Goal

Spins up Kafka, Zookeeper, Kafka Manager, and MongoDB for use with a new post I am writing, 'Using Eventual Consistency and Spring Kafka to Manage a Microservice-based Distributed Data Model: Part 1 of 2'.

Docker Compose file exposes ports so I can attach to containerized services from within my local Development environment.

## Usage

```bash
docker-compose -f docker-compose-local.yml up -d
```

## Results

```text
CONTAINER ID        IMAGE                            COMMAND                  CREATED             STATUS              PORTS                                                NAMES
7702732f45f1        hlebalbau/kafka-manager:latest   "/kafka-manager/bin/…"   7 days ago          Up 19 hours         0.0.0.0:9000->9000/tcp                               kafka-docker_kafka_manager_1
29da0675d0f7        wurstmeister/kafka:latest        "start-kafka.sh"         7 days ago          Up 19 hours         0.0.0.0:9092->9092/tcp                               kafka-docker_kafka_1
69ff95312167        wurstmeister/zookeeper:latest    "/bin/sh -c '/usr/sb…"   7 days ago          Up 19 hours         22/tcp, 2888/tcp, 3888/tcp, 0.0.0.0:2181->2181/tcp   kafka-docker_zookeeper_1
991e071911ae        mongo:latest                     "docker-entrypoint.s…"   9 days ago          Up 19 hours         0.0.0.0:27017->27017/tcp                             kafka-docker_mongo_1
```
