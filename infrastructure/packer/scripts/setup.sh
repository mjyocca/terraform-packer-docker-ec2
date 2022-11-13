#!/bin/bash
set -x

# Install necessary dependencies
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository 'deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable'
sudo apt-get update
sudo apt-get install -y amazon-ecr-credential-helper
sudo apt-get install -y docker-ce
# sudo groupadd docker
sudo usermod -aG docker ubuntu
