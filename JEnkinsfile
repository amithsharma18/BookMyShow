pipeline {
    agent any

    environment {
        NODE_ENV = "production"
    }

    stages {

        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Clone Repository') {
            steps {
                git branch: 'main',
                url: 'https://github.com/YOUR_USERNAME/Book-My-Show.git'
            }
        }

        stage('Check Versions') {
            steps {
                sh '''
                    java -version
                    node -v
                    npm -v
                '''
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Build Application') {
            steps {
                sh 'npm run build'
            }
        }

        stage('Archive Artifact') {
            steps {
                archiveArtifacts artifacts: '**/dist/**', fingerprint: true
            }
        }

    }

    post {
        success {
            echo 'Build Successful!'
        }

        failure {
            echo 'Build Failed!'
        }
    }
}
