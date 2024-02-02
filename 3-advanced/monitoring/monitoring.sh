#!/bin/bash

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/kube-prometheus-stack

# Accessing using Browser
kubectl port-forward deployment/prometheus-grafana 3000
# http://localhost:3000
# Username: admin
# Password: prom-operator