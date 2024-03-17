#!/bin/bash

# Checking disk usage
sudo du -h / | sort -h

# Step 1 Drain the node
kubectl drain this_node --ignore-daemonsets --delete-local-data

# Step 2 Stop kubelet on this node
service kubelet stop

# Step 3 Restart the docker on this node
service docker restart

# Step 4 Clean up the whole docker
docker system prune --all --volumes --force

# Delete unwanted files
find . -name "*.csv" -type f -delete

# Step 5 Start kubelet
service kubelet start

# Step 6 Uncordon the node
kubectl uncordon this_node
kubectl uncordon vmserverless0