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
