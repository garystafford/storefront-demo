```bash
# http://docs.spring.io/spring-cloud-stream/docs/current/reference/htmlsingle/#_configuration_options

git clone --depth 1 --branch master \
  https://github.com/garystafford/kafka-docker.git
cd kafka-docker

sh ./stack_deploy.sh

docker-machine env worker3
eval $(docker-machine env worker3)

docker logs  $(docker ps | grep zookeeper | awk '{print $NF}') --follow

docker run -it --network widget_overlay_net --rm busybox
echo stat | nc zookeeper 2181
echo mntr | nc zookeeper 2181
echo isro | nc zookeeper 2181
echo srvr | nc zookeeper 2181

docker exec -it  $(docker ps | grep kafka_stack_kafka | awk '{print $NF}') sh
cd /opt/kafka/bin

kafka-topics.sh --create --zookeeper zookeeper:2181 --replication-factor 1 --partitions 1 --topic test
kafka-topics.sh --list --zookeeper zookeeper:2181
kafka-topics.sh --describe --zookeeper zookeeper:2181 --topic test
kafka-console-producer.sh --broker-list localhost:9092 --topic test

kafka-topics.sh --create \
  --zookeeper zookeeper:2181 \
  --replication-factor 1 \
  --partitions 2 \
  --topic output

kafka-topics.sh --create --zookeeper zookeeper:2181 --replication-factor 1 --partitions 1 --topic output
kafka-console-consumer.sh --bootstrap-server localhost:9092 --from-beginning --topic output

kafka-console-producer.sh --broker-list localhost:9092 --topic outpout
kafka-topics.sh --delete --zookeeper localhost:2181 --topic test

# remote on swarm works
java -jar kafak-service-0.1.0.jar \
  --spring.cloud.stream.kafka.binder.brokers=192.168.99.105 \
  --spring.cloud.stream.kafka.binder.defaultBrokerPort=9092 \
  --spring.cloud.stream.kafka.binder.zkNodes=192.168.99.105 \
  --spring.cloud.stream.kafka.binder.defaultZkPort=2181

# local
docker-compose -f docker-compose-local.yml up -d

docker cp /Users/garystafford/IdeaProjects/spring_kafka_demo/build/libs/kafak-service-0.1.0.jar testapp:/kafak-service-0.1.0.jar

java -jar kafak-service-0.1.0.jar \
  --spring.cloud.stream.kafka.binder.brokers=kafka \
  --spring.cloud.stream.kafka.binder.defaultBrokerPort=9092 \
  --spring.cloud.stream.kafka.binder.zkNodes=zookeeper \
  --spring.cloud.stream.kafka.binder.defaultZkPort=2181

docker exec -it  $(docker ps | grep kafkadocker_kafka_1 | awk '{print $NF}') sh
```
