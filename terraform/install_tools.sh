#!/bin/bash
set -euxo pipefail
export DEBIAN_FRONTEND=noninteractive

# Core packages
apt-get update -y
apt-get install -y fontconfig openjdk-17-jre wget curl gnupg apt-transport-https lsb-release ca-certificates snapd

# Jenkins
mkdir -p /etc/apt/keyrings
wget -O /etc/apt/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" > /etc/apt/sources.list.d/jenkins.list
apt-get update -y
apt-get install -y jenkins
systemctl enable --now jenkins

# Docker
apt-get install -y docker.io
usermod -aG docker ubuntu
usermod -aG docker jenkins
systemctl enable --now docker
systemctl restart jenkins

# Trivy
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor --yes -o /usr/share/keyrings/trivy.gpg
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" > /etc/apt/sources.list.d/trivy.list
apt-get update -y
apt-get install -y trivy

# AWS CLI, Helm, kubectl
snap install aws-cli --classic
snap install helm --classic
snap install kubectl --classic
