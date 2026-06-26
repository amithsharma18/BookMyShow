pipeline {
    agent any

    environment {
        NODE_ENV = 'production'
    }

    stages {

        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Clone Repository') {
            steps {
                git branch: 'master',
                    url: 'https://github.com/amithsharma18/BookMyShow.git'
            }
        }

        stage('Check Versions') {
            steps {
                sh '''
                    echo "Java Version:"
                    java -version

                    echo "Node Version:"
                    node -v

                    echo "NPM Version:"
                    npm -v
                '''
            }
        }

        stage('Install Dependencies') {
            steps {
                dir('bookmyshow-app') {
                    sh 'npm install'
                }
            }
        }

        stage('Build Application') {
            environment {
                NODE_OPTIONS = '--openssl-legacy-provider'
                CI = 'false'
            }
            steps {
                dir('bookmyshow-app') {
                    sh 'npm run build'
                }
            }
        }

        stage('Archive Build') {
            steps {
                archiveArtifacts artifacts: 'bookmyshow-app/build/**', fingerprint: true
            }
        }

        stage('Build Docker Image') {
            steps {
                dir('bookmyshow-app') {
                    sh 'docker build -t bookmyshow:latest .'
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                sh '''
                    docker rm -f bookmyshow-container || true

                    docker run -d \
                        --name bookmyshow-container \
                        -p 3000:80 \
                        bookmyshow:latest
                '''
            }
        }
    }

    post {
        success {
            echo '✅ React application built and container started successfully.'
        }

        failure {
            echo '❌ Build failed.'
        }
    }
}
