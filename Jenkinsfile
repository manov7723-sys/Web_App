pipeline {
    agent any
    
    environment {
        DOCKERHUB_CREDS = credentials('dockerhub-creds')
        DOCKERHUB_USER = 'manov7723-sys'
        GITHUB_REPO = 'https://github.com/manov7723-sys/Web_App.git'
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
                        docker build -t ${vasanthmano}/mean-backend:latest ./backend
                        docker build -t ${vasanthmano}/mean-frontend:latest ./frontend
                        docker images | grep mean
                    """
                }
            }
        }
        
        stage('Test Images') {
            steps {
                script {
                    echo "Testing Docker images..."
                    sh """
                        docker run --rm ${vasanthmano}/mean-backend:latest echo "Backend OK"
                        docker run --rm ${vasanthmano}/mean-frontend:latest echo "Frontend OK"
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
                        docker push ${vasanthmano}/mean-backend:latest
                        docker push ${vasanthmano}/mean-frontend:latest
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
                        
                        # Cleanup old containers
                        docker-compose down -t 30 || true
                        
                        # Pull latest images
                        docker-compose pull
                        
                        # Deploy with health checks
                        docker-compose up -d --remove-orphans --force-recreate
                        
                        # Wait for services to start
                        echo "⏳ Waiting 30s for services..."
                        sleep 30
                        
                        # Verify deployment
                        docker-compose ps
                        
                        # Health checks
                        curl -f http://localhost:80 || (echo "Frontend failed!" && exit 1)
                        curl -f http://localhost:80/api || (echo "Backend API failed!" && exit 1)
                        curl -f http://localhost:3000 || (echo "Backend direct failed!" && exit 1)
                        
                        echo "All services healthy!"
                    """
                }
            }
        }
    }
    
    post {
        success {
            echo "MEAN Stack Deployed Successfully!"
            emailext (
                to: '${DEFAULT_RECIPIENTS}',
                subject: "MEAN Deploy Success - ${BUILD_NUMBER}",
                body: """
                MEAN Stack deployed successfully!<br/>
                <a href="${BUILD_URL}">View Build</a><br/>
                App: http://your-server-ip<br/>
                Build: ${BUILD_NUMBER}
                """
            )
            script {
                sh "docker image prune -f"
            }
        }
        failure {
            echo "Deployment Failed!"
            emailext (
                to: '${DEFAULT_RECIPIENTS}',
                subject: "MEAN Deploy Failed - ${BUILD_NUMBER}",
                body: """
                Deployment failed!<br/>
                <a href="${BUILD_URL}">View Logs</a><br/>
                Check docker-compose logs on server.
                """
            )
            script {
                sh "docker-compose logs"  
            }
        }
        always {
            script {
                sh """
                    docker system prune -f || true
                    docker logout || true
                """
            }
        }
    }
}
