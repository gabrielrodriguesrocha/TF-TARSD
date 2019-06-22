#!/bin/bash

# Swarm setup

sudo docker swarm init --advertise-addr 192.168.50.2:2377 | sed 5!d > /vagrant/token/join.sh
sudo docker network create -d overlay --subnet 10.0.10.0/24 ClusterNet
sudo docker volume create shared_files

# Prometheus Setup

cd TF-TARSD/prometheus_master

sudo docker build -t my-prometheus .
sudo docker run -p 9090:9090 --restart=always --detach=true --name=prometheus my-prometheus
sudo docker run -d --restart=always --net="host" --pid="host" --publish=9100:9100 --detach=true --name=node-exporter -v "/:/host:ro,rslave" quay.io/prometheus/node-exporter --path.rootfs /host
sudo docker run --restart=always --volume=/:/rootfs:ro --volume=/var/run:/var/run:ro --volume=/sys:/sys:ro --volume=/var/lib/docker/:/var/lib/docker:ro --volume=/dev/disk/:/dev/disk:ro --publish=8080:8080 --detach=true --name=cadvisor google/cadvisor:latest

cd ../services/file_transfer

sudo docker build -t file_transfer .
sudo docker service create -d --name file_transfer_service --mount source=shared_files,target=/usr/src/app --network ClusterNet --replicas 3 -p 5001:80 file_transfer

cd ../container_metrics

sudo docker build -t container_metrics .
sudo docker service create -d --name container_metrics_service --network ClusterNet container_metrics

cd ../vm_metrics

sudo docker build -t vm_metrics.
sudo docker service create -d --name vm_metrics_service --network ClusterNet vm_metrics
