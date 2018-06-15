# Kafka Docker

_Cloned from wurstmeister/kafka_  
See the source at: <http://wurstmeister.github.io/kafka-docker/>

## Goal

Spins up a Docker Swarm with a Docker Stack, including containers for Kafka, Zookeeper, Kafka Manager, MongoDB, Zuul, Eureka Server, and the three Storefront microservices. For use with a new post I am writing, 'Using Eventual Consistency and Spring for Kafka, to Manage a Microservice-based Distributed Data Model: Part 1 of 2'. Note there is no persistent storage backing Kafka or MongoDB.

In the Docker Compose file, you can chose uncomment the Kafka and MongoDB ports to expose them for local development.

## Usage

Build Docker Swarm and deploy Docker Stack.

```bash
docker swarm init
docker stack deploy -c docker-compose.yml storefront
```

Delete (3) MongoDB databases, (3) Kafka topics, create sample data by hitting Zuul API Gateway endpoints, and return MongoDB documents as verification.

```bash
python3 ./refresh.py
```

## Results

$ docker container ls

```text
CONTAINER ID        IMAGE                                        COMMAND                  CREATED             STATUS              PORTS                                  NAMES
ccf0e9a0637d        garystafford/storefront-fulfillment:latest   "java -jar -Djava.se…"   11 minutes ago      Up 11 minutes       8080/tcp                               storefront_fulfillment.1.0mht01m6nk461q7mt1ey4zsjb
f8a4654183cb        hlebalbau/kafka-manager:latest               "/kafka-manager/bin/…"   11 minutes ago      Up 11 minutes                                              storefront_kafka_manager.1.so9h6c8veemrwlznj5zdk3sdw
fe6579d68846        garystafford/storefront-accounts:latest      "java -jar -Djava.se…"   11 minutes ago      Up 11 minutes       8080/tcp                               storefront_accounts.1.nafdn02w68nixyvmz7l46kzcq
2495802b640b        garystafford/storefront-eureka:latest        "java -jar -Djava.se…"   11 minutes ago      Up 11 minutes       8761/tcp                               storefront_eureka.1.x2tu8vg1dnizx61lwnudrnsml
5afe1e94162f        wurstmeister/kafka:latest                    "start-kafka.sh"         12 minutes ago      Up 11 minutes                                              storefront_kafka.1.n55qrkbqfueg1sgz0fb9h47qu
44a9d4dbdc4b        mongo:latest                                 "docker-entrypoint.s…"   12 minutes ago      Up 11 minutes       27017/tcp                              storefront_mongo.1.tfy3u2zi4bpcmb7372ihdjmbc
23be66801ebc        garystafford/storefront-orders:latest        "java -jar -Djava.se…"   12 minutes ago      Up 11 minutes       8080/tcp                               storefront_orders.1.bo5hfnqb9ijbfd7vp88hcs3vn
bbe4dbe00048        wurstmeister/zookeeper:latest                "/bin/sh -c '/usr/sb…"   12 minutes ago      Up 12 minutes       22/tcp, 2181/tcp, 2888/tcp, 3888/tcp   storefront_zookeeper.1.ipfwro51ob6fpls26bk14lvkt
98b8084f0162        garystafford/storefront-zuul:latest          "java -jar -Djava.se…"   12 minutes ago      Up 12 minutes       8761/tcp                               storefront_zuul.1.u4h4bxp01mcwetyoezk19ljzt
```
