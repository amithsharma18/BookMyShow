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
    }

    post {
        success {
            echo '✅ React application built successfully.'
        }

        failure {
            echo '❌ Build failed.'
        }

        always {
            cleanWs()
        }
    }
}
