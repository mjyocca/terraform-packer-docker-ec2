#!/bin/bash

echo Installing Docker
sleep 10

# Install necessary dependencies
sudo apt-get update -y
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-commo
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository 'deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable'
sudo apt-get update
sudo apt-get install -y docker-ce amazon-ecr-credential-helper
sudo usermod -aG docker ubuntu
