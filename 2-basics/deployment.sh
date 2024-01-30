#!/bin/bash

# Kubernetes Deployments

kubectl get pod

kubectl get pod --watch

kubectl get pod -o wide

kubectl get deployment

kubectl create deployment nginx-depl --image=nginx

kubectl create deployment mongo-depl --image=mongo

kubectl edit deployment nginx-depl

kubectl delete deployment mongo-depl

kubectl delete deployment nginx-depl

kubectl get replicaset

kubectl logs {pod-name}

kubectl describe pod mongo-depl-{pod-name}

kubectl exec -it {pod-name} -- bin/bash

kubectl apply -f deployments/mongo-deployment.yaml
kubectl apply -f deployments/mongo-express-deployment.yaml

kubectl delete -f deployments/mongo-deployment.yaml
kubectl delete -f deployments/mongo-express-deployment.yaml