#!/bin/bash
#设置变量
NODE1=r1
NODE2=r2
NODE3=r3
ERLANG_COOKIE='EDDIRLDAFDAFDMALFJDAOI'
NET_NAME=rabbitmqnet
DEFAULT_USER=admin
DEFAULT_PASS=admin

docker rm -f $NODE1;
docker rm -f $NODE2;
docker rm -f $NODE3;

echo "创建网络"
docker network rm $NET_NAME
docker network create $NET_NAME

echo "启动节点"
function launch_node {
	NODE=$1
	AMQP_PORT=$2
	MGMT_PORT=$3
	docker run -d \
        	--name=$NODE \
        	-p $AMQP_PORT:5672 \
        	-p $MGMT_PORT:15672 \
        	-e RABBITMQ_NODENAME=$NODE \
			-e RABBITMQ_ERLANG_COOKIE=$ERLANG_COOKIE \
			-e RABBITMQ_DEFAULT_USER=$DEFAULT_USER \
			-e RABBITMQ_DEFAULT_PASS=$DEFAULT_PASS \
        	-h $NODE \
        	--net=$NET_NAME \
		rabbitmq:3.5-management
}

echo "正在启动节点容器..."
launch_node $NODE1 5672 15672
launch_node $NODE2 5673 15673
launch_node $NODE3 5674 15674

echo "等待节点就绪..."
sleep 3

echo "正在设置集群..."
echo $NODE2"加入集群"$NODE1"@"$NODE1
docker exec $NODE2 rabbitmqctl stop_app
docker exec $NODE2 rabbitmqctl join_cluster $NODE1@$NODE1
docker exec $NODE2 rabbitmqctl start_app

echo $NODE3"加入集群"$NODE1"@"$NODE1
docker exec $NODE3 rabbitmqctl stop_app
docker exec $NODE3 rabbitmqctl join_cluster --ram $NODE1@$NODE1
docker exec $NODE3 rabbitmqctl start_app

wait

echo "设置集群高可用策略"

#生产环境不建议这样设置，应该逐个设置需要进行镜像复制的队列
docker exec $NODE1 rabbitmqctl set_policy HA '^(?!amq\.).*' '{"ha-mode": "all"}'

echo "集群已运行：管理端：localhost:16672，管理账号:"$DEFAULT_USER"，密码："$DEFAULT_PASS
