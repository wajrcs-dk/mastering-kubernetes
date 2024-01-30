#!/bin/bash

# Helm Installation
curl -LO https://get.helm.sh/helm-v3.4.0-linux-amd64.tar.gz
tar -C /tmp/ -zxvf helm-v3.4.0-linux-amd64.tar.gz
rm helm-v3.4.0-linux-amd64.tar.gz
mv /tmp/linux-amd64/helm /usr/local/bin/helm
chmod +x /usr/local/bin/helm

# List our releases
helm list