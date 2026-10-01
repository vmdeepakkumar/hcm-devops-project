pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                echo 'Checking out HMSCI source code from GitHub'
            }
        }

        stage('Docker Build Test') {
            steps {
                bat 'docker --version'
                bat 'docker build -t hcm-devops-project:jenkins-test .'
            }
        }

    }

    post {
        success {
            echo 'HMSCI Jenkins CI pipeline completed successfully'
        }

        failure {
            echo 'HMSCI Jenkins CI pipeline failed'
        }
    }
}