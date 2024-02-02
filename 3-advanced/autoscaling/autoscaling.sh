#!/bin/bash

# Install Matrix Server
# https://github.com/kubernetes-sigs/metrics-server

# For production, make sure you remove the following :
# - --kubelet-insecure-tls
# - --kubelet-preferred-address-types="InternalIP"
kubectl apply -f metrics-server/components.yaml
kubectl get pods -n kube-system
kubectl top nodes
kubectl top pods

# Build and deploy example app
# build
cd application
docker build . -t wajrcs/application-cpu:v1.0.0
# push
docker push wajrcs/application-cpu:v1.0.0
# deploy
kubectl apply -f deployment.yaml
# metrics
kubectl top pods

# Generate some traffic
# Let's deploy a simple traffic generator pod
cd application
kubectl apply -f .\traffic-generator.yaml
# get a terminal to the traffic-generator
kubectl exec -it traffic-generator sh
# install wrk
apk add --no-cache wrk
# simulate some load
wrk -c 5 -t 5 -d 99999 -H "Connection: Close" http://application-cpu

# Deploy an autoscaler
# scale the deployment back down to 2
kubectl scale deploy/application-cpu --replicas 2

# Check API versions
kubectl api-versions

# deploy the autoscaler
kubectl autoscale deploy/application-cpu --cpu-percent=95 --min=1 --max=10

# pods should scale to roughly 6-7 to match criteria of 95% of resource requests
kubectl get pods
kubectl top pods
kubectl get hpa/application-cpu  -owide

# Get details about hpa
kubectl describe hpa/application-cpu