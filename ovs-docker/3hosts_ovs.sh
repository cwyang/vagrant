sudo ovs-vsctl add-br ovs-br1
sudo ovs-vsctl add-br ovs-br2
sudo ovs-vsctl show

docker run -dit --name=moby1 ubuntu
docker exec moby1 apt-get update
docker exec moby1 apt-get -y install iproute2 iputils-ping
sudo ovs-docker add-port ovs-br1 eth1 moby1 --ipaddress=192.168.0.1/24

docker run -dit --privileged --name=moby2 ubuntu
docker exec moby2 apt-get update
docker exec moby2 apt-get -y install iproute2 iputils-ping
sudo ovs-docker add-port ovs-br1 eth1 moby2
sudo ovs-docker add-port ovs-br2 eth2 moby2

docker run -dit --name=moby3 ubuntu
docker exec moby3 apt-get update
docker exec moby3 apt-get -y install iproute2 iputils-ping
sudo ovs-docker add-port ovs-br2 eth1 moby3 --ipaddress=192.168.0.2/24

docker exec moby2 ip link add name moby2-bridge type bridge
docker exec moby2 ip link set dev moby2-bridge up
docker exec moby2 ip link set dev eth1 master moby2-bridge
docker exec moby2 ip link set dev eth2 master moby2-bridge
docker exec -it moby2 ip link show
