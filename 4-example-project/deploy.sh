#!/bin/bash

# Launch Minikube
minikube start
minikube addons enable ingress

cd /vagrant_data/4-example-project/

# Building Project
eval $(minikube docker-env)
docker build . --target composer_base
docker build . --target web_server
docker compose build

# Verify Images
minikube image ls --format table

# Setup Mysql
kubectl apply -f ./kubernetes/mysql/mysql-configmap.yaml
kubectl apply -f ./kubernetes/mysql/mysql-services.yaml
kubectl apply -f ./kubernetes/mysql/mysql-statefulset.yaml
kubectl get pods -l app=mysql --watch

# Deploy Redis
kubectl apply -f ./kubernetes/redis/redis-configmap.yml
kubectl apply -f ./kubernetes/redis/redis-statefulset.yml
kubectl apply -f ./kubernetes/redis/redis-service.yml

# Setup Config Maps
kubectl apply -f ./kubernetes/common/

# Deploy FPM
kubectl apply -f ./kubernetes/fpm/deployment.yml
kubectl apply -f ./kubernetes/fpm/service.yml

# Deploy Webserver
kubectl apply -f ./kubernetes/webserver/deployment.yml
kubectl apply -f ./kubernetes/webserver/service.yml

# Deploy PhpMyAdmin
kubectl apply -f ./kubernetes/phpmyadmin/deployment.yml
kubectl apply -f ./kubernetes/phpmyadmin/service.yml
kubectl port-forward service/laravel-in-kubernetes-phpmyadmin 8080:80

# database
# dzhw-laravel-charts

# Deploy Ingress
kubectl apply -f ./kubernetes/ingress/ingress.yml

# Domain name
# dzhw-charts.de
# or
# laravel-project
