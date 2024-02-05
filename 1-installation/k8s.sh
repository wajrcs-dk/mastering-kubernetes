#!/bin/bash

# Installation Guide
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

# Step 1.
# Disable swap
sudo swapoff -a
# Keeps the swap off during reboot
(crontab -l 2>/dev/null; echo "@reboot /sbin/swapoff -a") | crontab - || true

# Update the packages repository
sudo apt-get update -y

# Step 2.
# Install Docker
# https://docs.docker.com/engine/install/ubuntu/

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Check docker installation
sudo docker run hello-world

# Step 3 (in case of docker only).
# Install cri docker
# https://github.com/Mirantis/cri-dockerd

git clone https://github.com/Mirantis/cri-dockerd.git
cd cri-dockerd

# Download release from here https://github.com/Mirantis/cri-dockerd/releases as cri-dockerd file
# For instance https://github.com/Mirantis/cri-dockerd/releases/download/v0.3.9/cri-dockerd-0.3.9.amd64.tgz
# Extract and copy the file as cri-dockerd in current directory
mkdir -p /usr/local/bin
sudo install -o root -g root -m 0755 ./cri-dockerd /usr/local/bin/cri-dockerd
sudo install packaging/systemd/* /etc/systemd/system
sudo sed -i -e 's,/usr/bin/cri-dockerd,/usr/local/bin/cri-dockerd,' /etc/systemd/system/cri-docker.service
sudo systemctl daemon-reload
sudo systemctl enable --now cri-docker.socket

# Step 4.
# Install Kubernetes
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# Step 5.
# On each master node
# https://v1-28.docs.kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/
sudo kubeadm init --apiserver-advertise-address=192.168.33.70 --pod-network-cidr=192.168.0.0/16 --cri-socket=unix://var/run/cri-dockerd.sock
# or if on class A IP address
sudo kubeadm init --apiserver-advertise-address=10.4.110.208 --pod-network-cidr=10.244.0.0/16 --cri-socket=unix://var/run/cri-dockerd.sock
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl get pods -A

# Deploy calico network
# You must deploy a Container Network Interface (CNI) based Pod network add-on so that your Pods can communicate with each other
curl https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/calico.yaml -O
kubectl apply -f calico.yaml
kubectl get pods -A --watch

# Step 6.
# On each worker node
# To reset kubeadm
sudo kubeadm reset --cri-socket=unix:///var/run/cri-dockerd.sock
# To join node with master
sudo kubeadm join 192.168.33.70:6443 --token qy1l17.h52cdhdrrrh1opib --discovery-token-ca-cert-hash sha256:9872e8b03dacee1575e22f7d0896138285e37aed8b7bae1e772ff0b6aaf46ddb --cri-socket=unix:///var/run/cri-dockerd.sock

# On master node
# Deploy sample app
kubectl apply -f sample-app.yaml