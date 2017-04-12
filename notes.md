```bash
git clone --depth 1 --branch master \
  https://github.com/garystafford/kafka-docker.git
cd kafka-docker

sh ./stack_deploy.sh

docker-machine env worker3
eval $(docker-machine env worker3)
docker logs  $(docker ps | grep zookeeper | awk '{print $NF}') --follow
docker logs  $(docker ps | grep kafka | awk '{print $NF}') --follow

```
