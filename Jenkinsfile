pipeline {
    agent any
    
    environment {
        AWS_CREDENTIALS_ID = 'aws-credentials-id'  // Update with your AWS credentials ID in Jenkins
        AWS_REGION         = 'us-west-2'  // Update with your desired AWS region
    }

    stages {
        stage('Clone Repository') {
            steps {
                // Clean workspace before cloning
                deleteDir()
                
                // Clone the Git repository
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], userRemoteConfigs: [[url: 'https://github.com/eldarsh1/NiceExam.git']]])
            }
        }

        stage('Deploy Terraform') {
            steps {
                script {
                    // Fetch AWS credentials from Jenkins credentials
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: AWS_CREDENTIALS_ID, accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                        
                        // Set AWS CLI environment variables
                        env.AWS_ACCESS_KEY_ID     = sh(script: 'echo $AWS_ACCESS_KEY_ID', returnStdout: true).trim()
                        env.AWS_SECRET_ACCESS_KEY = sh(script: 'echo $AWS_SECRET_ACCESS_KEY', returnStdout: true).trim()

                        // Set Terraform environment variables
                        env.TF_VAR_aws_access_key = env.AWS_ACCESS_KEY_ID
                        env.TF_VAR_aws_secret_key = env.AWS_SECRET_ACCESS_KEY

                        // Initialize Terraform
                        sh 'terraform init'

                        // Apply Terraform changes
                        sh 'terraform apply -auto-approve'
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline succeeded! You can add notifications or additional actions here.'
        }
        failure {
            echo 'Pipeline failed! You can add notifications or additional actions here.'
        }
    }
}
