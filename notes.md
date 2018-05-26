```bash
# http://docs.spring.io/spring-cloud-stream/docs/current/reference/htmlsingle/#_configuration_options
# http://ronnieroller.com/kafka/cheat-sheet

git clone --depth 1 --branch master https://github.com/garystafford/kafka-docker.git
cd kafka-docker

sh ./stack_deploy.sh

docker-machine env worker3
eval $(docker-machine env worker3)

docker logs $(docker ps | grep zookeeper | awk '{print $NF}') --follow

docker run -it --network widget_overlay_net --rm busybox

echo stat | nc zookeeper 2181
echo mntr | nc zookeeper 2181
echo isro | nc zookeeper 2181
echo srvr | nc zookeeper 2181

docker exec -it $(docker ps | grep kafka-docker_kafka_1 | awk '{print $NF}') sh
cd /opt/kafka/bin

kafka-topics.sh --create --zookeeper zookeeper:2181 --replication-factor 1 --partitions 1 --topic test
kafka-topics.sh --list --zookeeper zookeeper:2181
kafka-topics.sh --describe --zookeeper zookeeper:2181 --topic test
kafka-console-producer.sh --broker-list localhost:9092 --topic test

kafka-console-consumer.sh --bootstrap-server localhost:9092 --from-beginning --topic test


kafka-topics.sh --create --zookeeper zookeeper:2181 --replication-factor 1 --partitions 2 --topic output

kafka-topics.sh --create --zookeeper zookeeper:2181 --replication-factor 1 --partitions 1 --topic output

kafka-console-consumer.sh --bootstrap-server localhost:9092 --from-beginning --topic output

kafka-configs.sh --zookeeper zookeeper:2181 --alter --entity-type topics --entity-name output --add-config retention.ms=1000

kafka-configs.sh --zookeeper zookeeper:2181 --describe --entity-type topics --entity-name output

kafka-console-producer.sh --broker-list localhost:9092 --topic output
kafka-topics.sh --delete --zookeeper zookeeper:2181 --topic output

# remote on swarm works
java -jar spring-kafka-demo-1.0.0.jar \
  --spring.cloud.stream.kafka.binder.brokers=192.168.99.105 \
  --spring.cloud.stream.kafka.binder.defaultBrokerPort=9092 \
  --spring.cloud.stream.kafka.binder.zkNodes=192.168.99.105 \
  --spring.cloud.stream.kafka.binder.defaultZkPort=2181

# local testapp container
sh ./start-kafka-local.sh
docker cp /Users/garystafford/Documents/projects/spring_kafka_demo/build/libs/spring-kafka-demo-1.0.0.jar testapp:/spring-kafka-demo-1.0.0.jar

docker exec -it testapp sh

java -jar spring-kafka-demo-1.0.0.jar \
  --spring.cloud.stream.kafka.binder.brokers=kafka \
  --spring.cloud.stream.kafka.binder.defaultBrokerPort=9092 \
  --spring.cloud.stream.kafka.binder.zkNodes=zookeeper \
  --spring.cloud.stream.kafka.binder.defaultZkPort=2181

# local kafka container (consume above messages)
docker exec -it $(docker ps | grep kafka-docker_kafka_1 | awk '{print $NF}') sh

cd /opt/kafka/bin

kafka-console-consumer.sh --bootstrap-server localhost:9092 --from-beginning --topic output
```
