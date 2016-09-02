# 基于容器运行RABBITMQ集群

## 单机演示

1. 直接运行 `sudo bash local_cluster.sh`.

## 分布式多主机启动顺序

1. 确定集群中的节点数（以下以3节点为例）
2. 在每个运行节点容器的真实主机的 `/etc/hosts` 文件中添加节点的IP映射，不要包含本主机所在节点，示例如下：
```
#三台ubuntu 14.04服务器IP地址
192.168.20.11 (节点1)
192.168.20.12 (节点2)
192.168.20.13 (节点3)
```
```
# 节点1真实主机hosts文件
...
192.168.20.12 r2
192.168.20.13 r3
...
```
```
# 节点2真实主机hosts文件
...
192.168.20.11 r1
192.168.20.13 r3
...
```
```
# 节点3真实主机hosts文件
...
192.168.20.11 r1
192.168.20.12 r2
...
```
3. `git clone git@github.com:freemanke/docker-rabbitmq-cluster`克隆到每个节点，对应每个节点修改每个节点对应的shell文件中的变量。
```
#根据实际需要更改COOKIE,DEFAULT_USER, DEFAULT_PASS参数
#一个集群内的所有节点这三个参数需要一样
NODE1=r1
NODE2=r2
NODE3=r3
COOKIE='NICAYNNZGMAHWQLRVQQU'
DEFAULT_USER=admin
DEFAULT_PASS=admin
DATA_PATH=/home/freeman/rabbitmq
```
3. 在1号节点上执行 `sudo bash r1.sh`
4. 在2号节点上执行 `sudo bash r2.sh`
5. 在3号节点上执行 `sudo bash r3.sh`
6. 访问`http://192.168.20.11:15672`查看集群运行状态
 ![RABBITMQ CLUSTER](http://i.imgur.com/251mf5L.png)
