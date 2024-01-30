#!/bin/bash

# Installation Guide
# https://docs.k0sproject.io/v1.29.1+k0s.0/k0s-multi-node/

# 1. Download k0s
curl -sSLf https://get.k0s.sh | sudo sh

# 2. Bootstrap a controller node
mkdir -p /etc/k0s
k0s config create > /etc/k0s/k0s.yaml
sudo k0s install controller -c /etc/k0s/k0s.yaml
sudo k0s start

# 3. Create a join token
sudo k0s token create --role=worker > token-file
# For enhanced security, run the following command to set an expiration time for the token:
sudo k0s token create --role=worker --expiry=100h > token-file

# 4. Add workers to the cluster
sudo k0s install worker --token-file /path/to/token/file
sudo k0s start

# 5. Add controllers to the cluster
# To create a join token for the new controller, run the following command on an existing controller:
sudo k0s token create --role=controller --expiry=1h > token-file
# On the new controller, run:
sudo k0s install controller --token-file /path/to/token/file -c /etc/k0s/k0s.yaml
sudo k0s start

# 6. Check k0s status
sudo k0s status

# 7. Access your cluster
sudo k0s kubectl get nodes