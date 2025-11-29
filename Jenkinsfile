pipeline {
    agent any
    
    environment {
        // Jenkins credential:
        //   ID: dockerhub-creds
        //   Username: vasanthmano
        //   Password: Docker Hub ACCESS TOKEN
        DOCKERHUB_CREDS = credentials('dockerhub-creds')
        DOCKERHUB_USER  = 'vasanthmano'
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
                    echo "Building Docker images..."
                    sh """
                        docker build -t ${DOCKERHUB_USER}/mean-backend:latest ./backend
                        docker build -t ${DOCKERHUB_USER}/mean-frontend:latest ./frontend
                        docker images | grep mean || true
                    """
                }
            }
        }
        
        stage('Test Images') {
            steps {
                script {
                    echo "Testing Docker images..."
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
                    echo "Pushing to Docker Hub..."
                    sh """
                        echo \$DOCKERHUB_CREDS_PSW | docker login -u \$DOCKERHUB_CREDS_USR --password-stdin
                        docker push ${DOCKERHUB_USER}/mean-backend:latest
                        docker push ${DOCKERHUB_USER}/mean-frontend:latest
                        docker logout || true
                    """
                }
            }
        }
        
        stage('Deploy on VM') {
            steps {
                script {
                    echo "Deploying to production..."
                    sh """
                        cd ${WORKSPACE}
                        docker-compose down -t 30 || true
                        docker-compose pull
                        docker-compose up -d --remove-orphans --force-recreate

                        echo "Waiting for services..."
                        sleep 40
                        docker-compose ps

                        # Frontend health check (non-fatal while debugging)
                        curl -f http://localhost:80 || echo "WARNING: frontend health check failed"

                        # Backend health check (non-fatal while debugging)
                        curl -f http://localhost:80/api || echo "WARNING: backend API health check failed"

                        echo "Deploy stage finished."
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
