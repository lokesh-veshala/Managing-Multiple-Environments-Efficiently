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
