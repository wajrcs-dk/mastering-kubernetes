#!/bin/bash

# Kubectl Common Commands
kubectl get nodes
kubectl top

# Example: Mongo + Mongo Express
kubectl apply -f secrets/mongo-secret.yaml
kubectl apply -f deployments/mongo-deployment.yaml
kubectl apply -f services/mongo-service.yaml
kubectl apply -f config-maps/mongo-config-map.yaml
kubectl apply -f deployments/mongo-express-deployment.yaml
kubectl apply -f services/mongo-express-service.yaml

# Deploy Ingress
kubectl apply -f ingress/ingress.yml

# If using NodePort with LoadBalancer
# minikube service mongo-express-service --url

# Accessing using Browser
# http://192.168.49.2:30000 (NodePort with LoadBalancer)
# http://mongo-dashboard.com (Ingress)
# Username: admin
# Password: pass