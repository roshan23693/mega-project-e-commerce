#!/bin/bash
# Exit immediately if a command exits with a non-zero status
set -e

# Update system and install core packages
sudo apt-get update -y
sudo apt-get install -y fontconfig openjdk-17-jre wget curl apt-transport-https gnupg lsb-release snapd

# Jenkins installation
sudo mkdir -p /usr/share/keyrings
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update -y
sudo apt-get install -y jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Docker installation
sudo apt-get install -y docker.io

# User group permission (Safe handling for root/cloud-init execution)
DEFAULT_USER=${SUDO_USER:-ubuntu}
sudo usermod -aG docker $DEFAULT_USER
sudo usermod -aG docker jenkins
sudo systemctl restart docker
sudo systemctl restart jenkins

# Trivy installation (Using modern key storage instead of deprecated apt-key)
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/trivy.list > /dev/null
sudo apt-get update -y
sudo apt-get install -y trivy

# AWS CLI installation
sudo snap install aws-cli --classic

# Helm installation
sudo snap install helm --classic

# Kubectl installation
sudo snap install kubectl --classic
