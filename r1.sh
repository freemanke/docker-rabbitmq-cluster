#-----------------------------------------------------
#主节点
#-----------------------------------------------------
#根据实际需要更改COOKIE,DEFAULT_USER, DEFAULT_PASS参数
#一个集群内的所有节点这三个参数需要一样
NODE1=r1
NODE2=r2
NODE3=r3
COOKIE='NICAYNNZGMAHWQLRVQQU'
DEFAULT_USER=admin
DEFAULT_PASS=admin
DATA_PATH=/home/freeman/rabbitmq

echo "如果容器"$NODE1"已启动，停止并重新启动"
docker rm -f $NODE1
docker run -d \
--name=$NODE1 \
-p 5671:5671 \
-p 15671:15671 \
-p 5672:5672 \
-p 15672:15672 \
-p 25672:25672 \
-p 4369:4369 \
-v /etc/hosts:/etc/hosts \
-v $DATA_PATH:/var/lib/rabbitmq \
-e RABBITMQ_DEFAULT_USER=$DEFAULT_USER \
-e RABBITMQ_DEFAULT_PASS=$DEFAULT_PASS \
-e RABBITMQ_NODENAME=$NODE1 \
-e RABBITMQ_ERLANG_COOKIE=$COOKIE \
--hostname $NODE1 \
rabbitmq:3.6.1-management

echo "等待"$NODE1"容器就绪..."
sleep 5
echo "设置高可用策略"
docker exec $NODE1 rabbitmqctl set_policy HA '^(?!amq\.).*' '{"ha-mode": "all"}'