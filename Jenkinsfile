pipeline {
    agent any

    stages {
        stage('Clone repository') {
            steps {
                git branch: 'master', credentialsId: 'your-github-credentials-id', url: 'https://github.com/eldarsh1/NiceExam.git'
            }
        }
        stage('Deploy to AWS') {
            steps {
                sh 'aws configure' // Configure AWS credentials
                sh 'terraform init' // Initialize Terraform
                sh 'terraform plan' // Run Terraform plan
                // Manually approve or reject the plan
                input 'Approve Plan?'
                sh 'terraform apply' // Apply Terraform if plan is approved
            }
        }
    }
}
