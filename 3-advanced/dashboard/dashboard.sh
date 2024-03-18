#!/bin/bash

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml

kubectl get all -n kubernetes-dashboard

# Change it to NodePort
kubectl edit service/kubernetes-dashboard -n kubernetes-dashboard

# Create token:
kubectl create serviceaccount admin-user -n kubernetes-dashboard
kubectl create clusterrolebinding admin-user --clusterrole=cluster-admin --serviceaccount=kubernetes-dashboard:admin-user
kubectl -n kubernetes-dashboard get secret $(kubectl -n kubernetes-dashboard get serviceaccount/admin-user -o jsonpath='{.secrets[0].name}') -o go-template='{{.data.token | base64decode}}'

# Get Token
kubectl -n kubernetes-dashboard create token admin-user

kubectl create clusterrole cr1 --verb list --resource pod,namespace
kubectl create clusterrolebinding crb1 --clusterrole cr1 --serviceaccount=kubernetes-dashboard:admin-user

# Destroy everything we created for dashboard:
kubectl delete -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
kubectl delete clusterrolebinding admin-user crb1
kubectl delete clusterrole cr1