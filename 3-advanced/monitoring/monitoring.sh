#!/bin/bash

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/kube-prometheus-stack

sudo apt-get install lubuntu-desktop -y

kubectl port-forward deployment/prometheus-grafana 3000

http://localhost:3000