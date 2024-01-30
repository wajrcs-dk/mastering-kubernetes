#!/bin/bash

# Installation Guide
# https://docs.k3s.io/installation

# Step 1. Installing K3s
curl -sfL https://get.k3s.io | sh -

# Check the K3s service status
systemctl status k3s

# Step 2. Checking Default Kubernetes Objects
sudo kubectl get all -n kube-system