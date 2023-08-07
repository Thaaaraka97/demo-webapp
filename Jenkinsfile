pipeline {
    agent any

    environment {
        // Define the Docker image name and tag
        DOCKER_IMAGE = "thaaaraka/custom_nginx_for_webapp" // Use the custom Nginx Docker image name
        DOCKER_TAG = "latest"
        DOCKERHUB_CREDENTIALS = credentials('docker-hub-credentials')
        REMOTE_USER = "ubuntu"
        REMOTE_IP = "10.0.25.66"
        
        
    }

    stages {
        stage('Checkout') {
            steps {
                // Fetch code from the GitHub repository
                checkout([$class: 'GitSCM', branches: [[name: '*/master']], 
                         userRemoteConfigs: [[url: 'https://github.com/Thaaaraka97/demo-webapp.git']]])
            }
        }

        stage('Build Docker Image') {
            steps {               
                sh 'docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .'
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                sh 'docker push ${DOCKER_IMAGE}:${DOCKER_TAG}'
                sh 'docker logout'
                
            }
        }

        stage('Deploy to Nginx Container') {
            steps {               
                sh """

                #!/bin/bash
                
                // SSH into the target VM and deploy the Nginx container 
                ssh ${REMOTE_USER}@${REMOTE_IP} << EOF

                // Stop and remove the existing Nginx container
                docker stop mynginx || true
                docker rm mynginx || true
                
                echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin
                docker pull ${DOCKER_IMAGE}:${DOCKER_TAG}

                // Deploy the newly built custom Nginx Docker image as an Nginx container
                docker run -d -p 80:80 --name mynginx ${DOCKER_IMAGE}:${DOCKER_TAG}
                docker logout
                exit 0
                << EOF

                """

                
            }
        }
    }

    post {
        
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Deployment failed!'
        }
    }
}
