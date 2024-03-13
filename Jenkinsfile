pipeline {
    agent any

    stages {
        stage('Clone Repository') {
            steps {
                script {
                    git 'https://github.com/eldarsh1/NiceExam.git'
                }
            }
        }

        stage('Deploy Terraform to AWS') {
            steps {
                script {
                    // Fetch AWS credentials from Jenkins credentials
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY', credentialsId: 'aws-credentials-id']]) {
                        // Change to the Terraform directory
                        dir('path/to/terraform/module') {
                            // Initialize and apply Terraform
                            sh 'terraform init'
                            sh 'terraform apply -auto-approve'
                        }
                    }
                }
            }
        }
    }
}
