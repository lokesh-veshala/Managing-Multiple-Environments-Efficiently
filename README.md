# Managing-Multiple-Environments-Efficiently
Managing multiple environments efficiently (development, staging, production, etc.). Ensuring consistency across these environments can be tricky, but there's a robust solution using Infrastructure as Code (IaC) and DevOps practices.


This repository demonstrates how to manage multiple environments (development, staging, production) efficiently using Terraform, Ansible, and Jenkins.
markdown
 
# Multi-Environment Infrastructure Management

This repository demonstrates how to manage multiple environments (development, staging, production) efficiently using Terraform, Ansible, and Jenkins.

## Overview

- **Terraform** is used for provisioning infrastructure.
- **Ansible** is used for configuration management.
- **Jenkins** is used to automate the deployment process.

## Prerequisites

- Terraform installed
- Ansible installed
- Jenkins installed and configured
- AWS account and credentials configured

## Terraform Configuration

Navigate to the `terraform/` directory and define your infrastructure in `main.tf` and `variables.tf`.

### main.tf

```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "app_server" {
  count = var.instance_count
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  tags = {
    Name = "AppServer"
    Environment = var.environment
  }
}
variables.tf
hcl
 
variable "instance_count" {
  description = "Number of instances"
  default     = 1
}

variable "environment" {
  description = "Environment name"
  default     = "development"
}
outputs.tf
hcl
 
output "instance_ids" {
  value = aws_instance.app_server[*].id
}

output "public_ips" {
  value = aws_instance.app_server[*].public_ip
}

## Ansible Playbook
Navigate to the ansible/ directory and define your playbook in playbook.yml.

playbook.yml 
 
- name: Configure App Servers
  hosts: app_servers
  become: yes
  tasks:
    - name: Install Nginx
      apt:
        name: nginx
        state: present

    - name: Start Nginx
      service:
        name: nginx
        state: started
        enabled: true
inventory.ini
 
[app_servers]
your_ec2_instance_public_ip ansible_ssh_private_key_file=~/.ssh/your_key.pem
Jenkins Pipeline
Define the Jenkins pipeline in Jenkinsfile at the root of the repository.

##Jenkinsfile: 
 
pipeline {
    agent any

    environment {
        TF_VAR_environment = 'staging'
    }

    stages {
        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }
        stage('Ansible Provisioning') {
            steps {
                dir('ansible') {
                    ansiblePlaybook credentialsId: 'ansible-vault-pass', playbook: 'playbook.yml', inventory: 'inventory.ini'
                }
            }
        }
    }
}
Usage - Clone the repository:

sh
 
git clone  https://github.com/lokesh-veshala/Managing-Multiple-Environments-Efficiently
cd Managing-Multiple-Environments-Efficiently
Set up Terraform:
Navigate to the terraform/ directory and run the following commands:
sh
terraform init
terraform apply -var environment=development -auto-approve

Run Ansible Playbook:
Navigate to the ansible/ directory and run the following command:
sh
ansible-playbook -i inventory.ini playbook.yml


Configure Jenkins:
Add this repository to your Jenkins.
Ensure you have the necessary plugins installed: Git, Ansible, Terraform.
Run the Jenkins pipeline.
Contributing
Feel free to open issues or submit pull requests for any improvements or suggestions.

