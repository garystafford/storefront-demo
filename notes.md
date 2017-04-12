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

```
