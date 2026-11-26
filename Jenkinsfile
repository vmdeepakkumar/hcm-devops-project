

pipeline {
    agent any

    environment {
        AWS_REGION = 'ap-south-2'
        ECR_REGISTRY = '327973843771.dkr.ecr.ap-south-2.amazonaws.com'
        ECR_REPOSITORY = 'hmsci-app'
        IMAGE_TAG = 'latest'
        EC2_HOST = '18.61.202.214'
        DOCKER_CONFIG = 'C:\\ProgramData\\Jenkins\\.docker-ecr'
        PATH+ECR = 'C:\\Program Files\\Docker\\Docker\\resources\\bin'
    }

    stages {

        stage('Preflight Check') {
            steps {
                bat 'where docker'
                bat 'docker version'
                bat 'where aws'
                bat 'aws --version'
                bat 'where ssh'
                bat 'ssh -V'
            }
        }

        stage('Docker Build') {
            steps {
                bat 'docker build -t %ECR_REGISTRY%/%ECR_REPOSITORY%:%IMAGE_TAG% .'
            }
        }

        stage('Prepare Docker Credentials') {
            steps {
                bat 'if not exist "%DOCKER_CONFIG%" mkdir "%DOCKER_CONFIG%"'
                bat 'aws sts get-caller-identity'
            }
        }

        stage('ECR Login') {
            steps {
                bat 'aws ecr get-login-password --region %AWS_REGION% | docker --config "%DOCKER_CONFIG%" login --username AWS --password-stdin %ECR_REGISTRY%'
            }
        }

        stage('Push to ECR') {
            steps {
                bat 'docker --config "%DOCKER_CONFIG%" push %ECR_REGISTRY%/%ECR_REPOSITORY%:%IMAGE_TAG%'
            }
        }

        stage('Deploy to EC2') {
            steps {
                sshagent(['hmsci-ec2']) {
                    bat '''
                        ssh -o StrictHostKeyChecking=no ec2-user@%EC2_HOST% "aws ecr get-login-password --region %AWS_REGION% | sudo docker login --username AWS --password-stdin %ECR_REGISTRY%"

                        ssh -o StrictHostKeyChecking=no ec2-user@%EC2_HOST% "sudo docker pull %ECR_REGISTRY%/%ECR_REPOSITORY%:%IMAGE_TAG%"

                        ssh -o StrictHostKeyChecking=no ec2-user@%EC2_HOST% "sudo docker stop hmsci-container || true"

                        ssh -o StrictHostKeyChecking=no ec2-user@%EC2_HOST% "sudo docker rm hmsci-container || true"

                        ssh -o StrictHostKeyChecking=no ec2-user@%EC2_HOST% "sudo docker run -d --name hmsci-container -p 5000:5000 %ECR_REGISTRY%/%ECR_REPOSITORY%:%IMAGE_TAG%"
                    '''
                }
            }
        }

        stage('Deployment Verification') {
            steps {
                sshagent(['hmsci-ec2']) {
                    bat '''
                        ssh -o StrictHostKeyChecking=no ec2-user@%EC2_HOST% "sudo docker ps --filter name=hmsci-container"

                        ssh -o StrictHostKeyChecking=no ec2-user@%EC2_HOST% "curl -fsS http://localhost:5000/health"
                    '''
                }
            }
        }
    }

    post {
        always {
            bat 'if exist "%DOCKER_CONFIG%\\config.json" del /f /q "%DOCKER_CONFIG%\\config.json"'
        }

        success {
            echo 'HMSCI CI/CD pipeline completed successfully'
        }

        failure {
            echo 'HMSCI CI/CD pipeline failed'
        }
    }
}
