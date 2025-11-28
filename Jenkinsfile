pipeline {
    agent any
    
    environment {
        DOCKERHUB_CREDS = credentials('dockerhub-creds')  
    }
    
    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/manov7723-sys/Web_App.git', credentialsId: 'github-creds'
            }
        }
        
        stage('Build Docker Images') {
            steps {
                script {
                    sh "docker build -t \$DOCKERHUB_CREDS_USR/mean-backend:latest ./backend"
                    sh "docker build -t \$DOCKERHUB_CREDS_USR/mean-frontend:latest ./frontend"
                }
            }
        }
        
        stage('Push Images to Docker Hub') {
            steps {
                script {
                    sh "echo \$DOCKERHUB_CREDS_PSW | docker login -u \$DOCKERHUB_CREDS_USR --password-stdin"
                    sh "docker push \$DOCKERHUB_CREDS_USR/mean-backend:latest"
                    sh "docker push \$DOCKERHUB_CREDS_USR/mean-frontend:latest"
                }
            }
        }
        
        stage('Deploy on Same VM') {
            steps {
                script {
                    sh """
                        cd ${WORKSPACE}
                        docker-compose pull
                        docker-compose up -d --remove-orphans
                    """
                }
            }
        }
    }
    
    post {
        success { echo "Deployment completed successfully!" }
        failure { echo "Deployment failed!" }
    }
}
