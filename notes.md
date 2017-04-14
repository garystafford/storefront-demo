```bash
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
cd /opt/kafka_2.12-0.10.2.0

wget --header "Content-Type: application/vnd.kafka.binary.v1+json" \
  --post-data='{"records":[{"value":"S2Fma2E="}]}' "http://192.168.99.105:9092/topics/test"
wget "http://localhost:9092/topics"

kafka-topics.sh --create --zookeeper zookeeper:2181 --replication-factor 1 --partitions 1 --topic test
kafka-topics.sh --list --zookeeper zookeeper:2181
kafka-topics.sh --describe --zookeeper zookeeper:2181 --topic test
kafka-console-producer.sh --broker-list localhost:9092 --topic test


bin/kafka-topics.sh --create \
  --zookeeper zookeeper:2181 \
  --replication-factor 1 \
  --partitions 1 \
  --topic streams-file-input

bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --from-beginning --topic output
```
