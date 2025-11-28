pipeline {
    agent any
    
    environment {
        DOCKERHUB_USER = credentials('vasanthmano') 
        DOCKERHUB_PASS = credentials('Moto@1234')  
    }
    
    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'git@github.com:manov7723-sys/Web_App.git', credentialsId: 'github-ssh'  
            }
        }
        
        stage('Build Docker Images') {
            steps {
                script {
                    sh "docker build -t vasanthmano/mean-backend:latest ./backend"
                    sh "docker build -t vasanthmano/mean-frontend:latest ./frontend"
                }
            }
        }
        
        stage('Push Images to Docker Hub') {
            steps {
                script {
                    sh "echo \$Moto@1234 | docker login -u \$vasanthmano --password-stdin"
                    sh "docker push vasanthmano/mean-backend:latest"
                    sh "docker push vasanthmano/mean-frontend:latest"
                }
            }
        }
        
        stage('Deploy on Same VM') {
            steps {
                script {
                    sh """
                        cd ~/mean-app || mkdir -p ~/mean-app
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
