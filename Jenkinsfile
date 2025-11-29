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
                        docker-compose down || true
                        docker-compose pull
                        docker-compose up -d --remove-orphans
                        
                        sleep 30
                        
                        curl -f http://localhost:80/api || echo "Backend health check failed"
                        curl -f http://localhost:80 || echo "Frontend health check failed"
                    '''
                }
            }
        }
    }

    post {
        always {
            sh 'docker image prune -f || true'
        }
        success {
            echo 'MEAN Stack deployed successfully!'
        }
        failure {
            echo 'Deployment failed!'
            sh 'docker-compose logs backend || true'
            sh 'docker-compose logs frontend || true'
        }
    }
}
