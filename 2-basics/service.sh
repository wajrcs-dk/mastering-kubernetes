#!/bin/bash

# Kubernetes Service

kubectl get services

kubectl apply -f services/mongo-service.yaml

kubectl apply -f services/mongo-express-service.yaml

kubectl describe service mongodb-service

minikube service mongo-express-service
