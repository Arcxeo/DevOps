# DevOps EFREI - Final Project

## Group

Nicolas PAPLEUX, Romain DANGIN, Ali BALHASSEN, Nail FAHIM, Arnaud VAN EECKHOVEN

## Project objective

This repository contains a DevOps Proof of Concept focused on a complete CI/CD pipeline.

The goal is to demonstrate how an application can be automatically built, tested, packaged, deployed and verified using Jenkins, Docker, Vagrant and a production server.

The final implementation follows the requested architecture:

```text
VM1 - Jenkins Controller
IP: 192.168.56.10
Role: pipeline orchestrator

VM2 - Docker Agent Host
IP: 192.168.56.20
Role: creates temporary Jenkins agents as Docker containers

VM3 - Production Server
IP: 192.168.56.30
Role: hosts only the deployed application and its configuration
```

## Repository structure

```text
.
├── labs/
│   ├── lab-1-basic-ci-cd/
│   ├── lab-2-docker-agent/
│   │   ├── app/
│   │   └── jenkins-agent/
│   └── lab-3-ansible/
│
├── final-project/
│   ├── Jenkinsfile
│   ├── production/
│   │   └── Vagrantfile
│   └── scripts/
│       ├── deploy-production.sh
│       └── verify-production.sh
│
├── .gitignore
└── README.md
```

## Final CI/CD pipeline

The final pipeline is defined in:

```text
final-project/Jenkinsfile
```

It contains the following stages:

```text
Checkout
Prepare Scripts
Build
Test
Build Docker Image
Push Docker Image
Deploy to Production
Verify Production
Notify Discord
```

Pipeline behavior:

1. Jenkins starts the pipeline from VM1.
2. Jenkins dynamically creates a Docker-based agent on VM2.
3. The agent installs dependencies and runs unit tests.
4. The application Docker image is built.
5. The image is pushed to DockerHub.
6. Jenkins connects to the production server by SSH.
7. The production server pulls the new Docker image.
8. The old application container is replaced.
9. A post-deployment health check verifies the application.
10. A Discord notification is sent on success or failure.
11. The Docker agent is destroyed after the pipeline execution.

## Application

The demonstration application is a small Node.js / Express application located in:

```text
labs/lab-2-docker-agent/app
```

Available routes:

```text
GET /
GET /health
```

Expected responses:

```text
GET /        → Hello from CI/CD pipeline!
GET /health  → {"status":"OK"}
```

## Prerequisites

Required tools on the host machine:

```text
VirtualBox
Vagrant
Git
Jenkins installed and running on VM1
DockerHub account
Discord webhook
```

Jenkins plugins required:

```text
Docker plugin
Pipeline
Git
Credentials
SSH Agent / SSH Credentials
```

## Virtual machines

### VM2 - Docker agent host

Path:

```text
labs/lab-2-docker-agent
```

Start VM2:

```bash
cd labs/lab-2-docker-agent
vagrant up
```

VM2 configuration:

```text
IP: 192.168.56.20
Docker API: tcp://192.168.56.20:2375
Forwarded app port: localhost:3001
```

The Jenkins agent image must exist on VM2:

```bash
cd /vagrant/jenkins-agent
docker build --no-cache -t devops-jenkins-agent:v2 .
```

### VM3 - Production server

Path:

```text
final-project/production
```

Start VM3:

```bash
cd final-project/production
vagrant up
```

VM3 configuration:

```text
IP: 192.168.56.30
Application port inside VM: 3000
Forwarded host port: localhost:3002
```

## Jenkins configuration

Create a Jenkins Pipeline job:

```text
Job name: DevOps-Final-Project
Type: Pipeline from SCM
Repository: https://github.com/Arcxeo/DevOps.git
Branch: main
Script Path: final-project/Jenkinsfile
```

## Jenkins Docker cloud

In Jenkins:

```text
Manage Jenkins
→ Clouds
→ New cloud
→ Docker
```

Configuration:

```text
Name: docker-vm2-clean
Docker Host URI: tcp://192.168.56.20:2375
Container Cap: 1
```

Docker agent template:

```text
Labels: docker-dynamic-agent
Docker image: devops-jenkins-agent:v2
Remote File System Root: /tmp/jenkins-agent
Connect method: Attach Docker container
User: jenkins
Command: cat
Pull strategy: Never pull
Instance capacity: 1
```

The label must exactly match the Jenkinsfile:

```text
docker-dynamic-agent
```

## Jenkins credentials

The pipeline requires three Jenkins credentials.

### DockerHub credentials

```text
ID: dockerhub-credentials
Type: Username with password
Username: DockerHub username
Password: DockerHub token
```

### Production SSH key

```text
ID: production-ssh-key
Type: SSH Username with private key
Username: vagrant
Private key: private key allowed on VM3
```

This key allows Jenkins to connect to:

```text
vagrant@192.168.56.30
```

### Discord webhook

```text
ID: discord-webhook-url
Type: Secret text
Secret: Discord webhook URL
```

## Run the pipeline

In Jenkins:

```text
DevOps-Final-Project
→ Build Now
```

Expected result:

```text
SUCCESS
```

The successful pipeline proves that:

```text
Build is working
Unit tests are passing
Docker image is created
Docker image is pushed to DockerHub
Application is deployed to VM3
Health check is successful
Discord notification is sent
Temporary Docker agent is destroyed after execution
```

## Verify the deployment

From the host machine or browser:

```text
http://192.168.56.30:3000
http://192.168.56.30:3000/health
```

Expected results:

```text
Hello from CI/CD pipeline!
```

```json
{"status":"OK"}
```

Production can also be accessed through the forwarded port:

```text
http://localhost:3002
```

## DockerHub image

The pipeline pushes the application image to DockerHub:

```text
arnaudve/devops-lab02:build-<BUILD_NUMBER>
arnaudve/devops-lab02:latest
```

## Useful verification commands

Check VM2 Docker API from Jenkins or VM1:

```bash
curl http://192.168.56.20:2375/version
```

Check production health endpoint:

```bash
curl http://192.168.56.30:3000/health
```

Check production home page:

```bash
curl http://192.168.56.30:3000
```

Check running container on VM3:

```bash
docker ps
```

Expected production container name:

```text
devops-final-app
```

## Evidence for the final report

Recommended screenshots:

```text
Jenkins final pipeline in SUCCESS
Jenkins console logs for Build, Test, Deploy and Verify stages
Temporary Docker agent created on VM2 during the build
Docker agent removed after the build
DockerHub image tags
Production container running on VM3
Application /health endpoint responding OK
Discord notification
VirtualBox showing the three VMs
```

## Notes

The `labs/` directory contains previous lab work and intermediate steps.

The final evaluated implementation is located in:

```text
final-project/
```

The production server contains only the deployed application container and its configuration.
