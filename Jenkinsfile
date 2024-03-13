pipeline {
    agent any

    stages {
        stage('Clone repository') {
            steps {
                git branch: 'master', credentialsId: 'your-github-credentials-id', url: 'https://github.com/eldarsh1/NiceExam.git'
            }
        }
    }
}