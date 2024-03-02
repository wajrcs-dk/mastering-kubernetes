#!/bin/bash

# Nodes related commands
kubectl get nodes
kubectl top

# Apply any folder or yaml file
kubectl apply -f ./yyy/xxx.yaml
kubectl apply -f ./yyy/

# Get ConfigMap and Secrets
kubectl get secret
kubectl get configmap

# Deployments
kubectl get deployment
kubectl create deployment nginx-depl --image=nginx
kubectl edit deployment nginx-depl
kubectl delete deployment nginx-depl
kubectl get replicaset

# Pods
kubectl get pod
kubectl get pod --watch
kubectl logs {pod-name}
kubectl describe pod nginx-depl-{pod-name}
kubectl exec -it {pod-name} -- bin/bash

# Services
kubectl get services
kubectl describe service nginx-service
