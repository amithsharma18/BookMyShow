pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "YOUR_DOCKERHUB_USERNAME/bms"
        IMAGE_TAG    = "latest"
    }

    stages {
        stage('Checkout from Git') {
            steps {
                git branch: 'main', url: 'https://github.com/YOUR_GITHUB_USERNAME/Book-My-Show.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE}:${IMAGE_TAG} -f bookmyshow-app/Dockerfile bookmyshow-app"
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withDockerRegistry(credentialsId: 'dockerhub-creds', toolName: 'docker') {
                    sh "docker push ${DOCKER_IMAGE}:${IMAGE_TAG}"
                }
            }
        }

        stage('Deploy with Ansible') {
            steps {
                sh "ansible-playbook -i ansible/inventory.ini ansible/playbook.yml --tags deploy"
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully. App should be live on port 3000."
        }
        failure {
            echo "Pipeline failed. Check the stage logs above."
        }
    }
}
