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

# Accessing using Browser
minikube service mongo-express-service --url
# http://192.168.49.2:30000
# Username: admin
# Password: pass