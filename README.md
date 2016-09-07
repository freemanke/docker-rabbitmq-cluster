# 基于容器运行RABBITMQ集群

镜像队列有主从之分，一个主节点(master)，0个或多个从节点(slave)。当master宕掉后，会在slave中选举新的master。选举算法为最早启动的节点。最好在加的时候 重新确认一下主节点。

**注意：**不要手动docker stop主节点，可以kill掉主节点的docker，总之默认异常关闭主节点，主节点会重新选举，但是正常用stop命令关闭主节点，会造成整个集群出现问题。

## 单机演示

1. 直接运行 `sudo bash local_cluster.sh`.

## 分布式多主机启动顺序

1. 确定集群中的节点数（最好设计使用集群之前想好要使用几个节点，如果要部署后再新加节点，比较麻烦，要把每个节点的hosts文件都修改才行），以下以3节点为例，
3. `git clone git@github.com:freemanke/docker-rabbitmq-cluster`克隆到每个节点，对应每个节点修改每个节点对应的shell文件中的变量。
```
#根据实际需要更改COOKIE,DEFAULT_USER, DEFAULT_PASS参数
#一个集群内的所有节点这三个参数需要一样
NODE1_IP=192.168.10.1
NODE2_IP=192.168.10.2
NODE3_IP=192.178.10.3
COOKIE='NICAYNNZGMAHWQLRVQQU'
DEFAULT_USER=admin
DEFAULT_PASS=admin
DATA_PATH=/var/rabbitmq
NODE1=r1
NODE2=r2
NODE3=r3
```
3. 在1号节点上执行 `sudo bash r1.sh`
4. 在2号节点上执行 `sudo bash r2.sh`
5. 在3号节点上执行 `sudo bash r3.sh`
6. 访问`http://192.168.20.11:15672`查看集群运行状态
 ![RABBITMQ CLUSTER](http://i.imgur.com/251mf5L.png)
