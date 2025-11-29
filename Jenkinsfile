pipeline {
    agent any
    
    environment {
        DOCKERHUB_CREDS = credentials('dockerhub-creds')
        DOCKERHUB_USER = 'manov7723-sys'
    }
    
    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', 
                    url: 'https://github.com/manov7723-sys/Web_App.git', 
                    credentialsId: 'github-creds'
                echo "Code checked out from GitHub"
            }
        }
        
        stage('Build Docker Images') {
            steps {
                script {
                    sh """
                        docker build -t ${DOCKERHUB_USER}/mean-backend:latest ./backend
                        docker build -t ${DOCKERHUB_USER}/mean-frontend:latest ./frontend
                        docker images | grep mean
                    """
                }
            }
        }
        
        stage('Test Images') {
            steps {
                script {
                    sh """
                        docker run --rm ${DOCKERHUB_USER}/mean-backend:latest echo "Backend OK"
                        docker run --rm ${DOCKERHUB_USER}/mean-frontend:latest echo "Frontend OK"
                    """
                }
            }
        }
        
        stage('Push Images to Docker Hub') {
            steps {
                script {
                    sh """
                        echo \$DOCKERHUB_CREDS_PSW | docker login -u \$DOCKERHUB_CREDS_USR --password-stdin
                        docker push ${DOCKERHUB_USER}/mean-backend:latest
                        docker push ${DOCKERHUB_USER}/mean-frontend:latest
                    """
                }
            }
        }
        
        stage('Deploy on VM') {
            steps {
                script {
                    sh """
                        cd ${WORKSPACE}
                        docker-compose down -t 30 || true
                        docker-compose pull
                        docker-compose up -d --remove-orphans --force-recreate
                        sleep 30
                        docker-compose ps
                        curl -f http://localhost:80 || exit 1
                        curl -f http://localhost:80/api || exit 1
                        echo "Deployment successful - All services healthy!"
                    """
                }
            }
        }
    }
    
    post {
        success {
            echo "MEAN Stack Deployed Successfully!"
            sh "docker image prune -f || true"
        }
        failure {
            echo "Deployment Failed!"
            sh "docker-compose logs nginx || true"
            sh "docker-compose logs backend || true"
        }
        always {
            sh "docker image prune -f || true"
        }
    }
}
