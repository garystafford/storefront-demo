```bash
git clone --depth 1 --branch master \
  https://github.com/garystafford/kafka-docker.git
cd kafka-docker

sh ./stack_deploy.sh

docker-machine env worker3
eval $(docker-machine env worker3)
```
