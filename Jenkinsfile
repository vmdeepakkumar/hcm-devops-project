pipeline {
    agent any

    environment {
        AWS_REGION = 'ap-south-2'
        ECR_REGISTRY = '327973843771.dkr.ecr.ap-south-2.amazonaws.com'
        ECR_REPOSITORY = 'hmsci-app'
        IMAGE_TAG = 'latest'
    }

    stages {

        stage('Checkout') {
            steps {
                echo 'Checking out HMSCI source code from GitHub'
            }
        }

        stage('Docker Build') {
            steps {
                bat 'docker build -t %ECR_REGISTRY%/%ECR_REPOSITORY%:%IMAGE_TAG% .'
            }
        }

        stage('ECR Login') {
            steps {
                bat 'aws ecr get-login-password --region %AWS_REGION% | docker login --username AWS --password-stdin %ECR_REGISTRY%'
            }
        }

        stage('Push to ECR') {
            steps {
                bat 'docker push %ECR_REGISTRY%/%ECR_REPOSITORY%:%IMAGE_TAG%'
            }
        }
    }

    post {
        success {
            echo 'HMSCI CI pipeline completed successfully'
        }

        failure {
            echo 'HMSCI CI pipeline failed'
        }
    }
}