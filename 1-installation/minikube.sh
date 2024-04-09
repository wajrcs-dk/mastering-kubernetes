#!/bin/bash

# Installation Guide
# https://minikube.sigs.k8s.io/docs/start/

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER && newgrp docker

# Install Minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# Install Kubectl
sudo snap install kubectl --classic

# Start Minikube
minikube start

# Deploy sample app
kubectl apply -f /vagrant_data/mastering-kubernetes/1-installation/nginx-app.yaml

# Testing service
echo  $(minikube ip)
curl $(minikube ip):32000

# Install Desktop UI and Firefox
sudo apt-get update
sudo apt-get install lubuntu-desktop -y
sudo apt-get install firefox -y

# Halt cluster
minikube stop

# Delete cluster
minikube delete

##### Additional Commands #####

# Start Minikube with insecure registry
minikube start --insecure-registry="192.168.49.2:5000"

# Change the default memory limit (requires a restart):
minikube config set memory 8000
minikube config set cpus 4

# Create a second cluster running an older Kubernetes release:
minikube start -p aged --kubernetes-version=v1.21.0

# Start with vm
minikube start --vm-driver=docker

# Start with certain roles and authorization
start --extra-config=apiserver.authorization-mode=RBAC

# Pause Kubernetes without impacting deployed applications:
minikube pause

# Unpause a paused instance:
minikube unpause

# Browse the catalog of easily installed Kubernetes services:
minikube addons list
