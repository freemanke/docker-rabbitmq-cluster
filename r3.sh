#-----------------------------------------------------
#第三节点（内存节点）
#-----------------------------------------------------
#根据实际需要更改COOKIE,DEFAULT_USER, DEFAULT_PASS参数
#一个集群内的所有节点这三个参数需要一样
NODE1=r1
NODE2=r2
NODE3=r3
COOKIE='NICAYNNZGMAHWQLRVQQU'
DEFAULT_USER=admin
DEFAULT_PASS=admin

echo "如果容器"$NODE3"已启动，停止并重新启动"
docker rm -f $NODE3
docker run -d \
--name=$NODE3 \
-p 5671:5671 \
-p 15671:15671 \
-p 5672:5672 \
-p 15672:15672 \
-p 25672:25672 \
-p 4369:4369 \
-v /etc/hosts:/etc/hosts \
-e RABBITMQ_DEFAULT_USER=admin \
-e RABBITMQ_DEFAULT_PASS=admin \
-e RABBITMQ_NODENAME=$NODE3 \
-e RABBITMQ_ERLANG_COOKIE=$COOKIE \
--hostname $NODE3 \
rabbitmq:3.6.1-management

echo "等待容器就绪"
sleep 3
echo "加入集群"$NODE1"@"$NODE1
docker exec $NODE3 rabbitmqctl stop_app
docker exec $NODE3 rabbitmqctl join_cluster --ram $NODE1@$NODE1
docker exec $NODE3 rabbitmqctl start_app