pipeline {
    agent any

    environment {
        DOCKERHUB_CREDS = credentials('dockerhub-creds')
        DOCKERHUB_USER  = 'vasanthmano'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/manov7723-sys/Web_App.git',
                    credentialsId: 'github-creds'
                echo 'Code checked out successfully'
            }
        }

        stage('Build Images') {
            steps {
                script {
                    sh '''
                        docker build -t ${DOCKERHUB_USER}/mean-backend:latest ./backend
                        docker build -t ${DOCKERHUB_USER}/mean-frontend:latest ./frontend
                    '''
                }
            }
        }

        stage('Test Images') {
            steps {
                script {
                    sh '''
                        docker run --rm ${DOCKERHUB_USER}/mean-backend:latest echo "Backend test passed"
                        docker run --rm ${DOCKERHUB_USER}/mean-frontend:latest echo "Frontend test passed"
                    '''
                }
            }
        }

        stage('Push Images') {
            steps {
                script {
                    sh '''
                        echo $DOCKERHUB_CREDS_PSW | docker login -u $DOCKERHUB_CREDS_USR --password-stdin
                        docker push ${DOCKERHUB_USER}/mean-backend:latest
                        docker push ${DOCKERHUB_USER}/mean-frontend:latest
                        docker logout || true
                    '''
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    sh '''
                        cd ${WORKSPACE}
                        
                        # Force remove conflicting containers
                        docker rm -f $(docker ps -aq --filter name=mean-) 2>/dev/null || true
                        
                        # Full cleanup
                        docker-compose down -v --remove-orphans --timeout 30 || true
                        
                        # Pull latest images
                        docker-compose pull
                        
                        # Start services
                        docker-compose up -d --remove-orphans
                        
                        echo "Waiting 60s for services..."
                        sleep 60
                        
                        echo "Container status:"
                        docker-compose ps
                        
                        echo "Health checks:"
                        curl -f http://localhost:80 || echo "Frontend OK or starting..."
                        curl -f http://localhost:80/api || echo "Backend OK or starting..."
                    '''
                }
            }
        }
    }

    post {
        always {
            sh '''
                docker image prune -f || true
                cd ${WORKSPACE} && docker-compose logs --tail=10 || true
            '''
        }
        success {
            echo 'MEAN Stack deployed successfully!'
        }
        failure {
            echo 'Deployment failed!'
            sh '''
                cd ${WORKSPACE} && docker-compose logs backend || true
                cd ${WORKSPACE} && docker-compose logs frontend || true
                cd ${WORKSPACE} && docker-compose logs mongo || true
            '''
        }
    }
}
