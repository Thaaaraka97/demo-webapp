pipeline {
    agent any

    environment {
        // Define the Docker image name and tag
        DOCKER_IMAGE = "mynginx" // Use the custom Nginx Docker image name
        DOCKER_TAG = "latest"
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
                // Build the custom Nginx Docker image using the provided Dockerfile
                // script {
                //     docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
                //         def customImage = docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}", "-f Dockerfile.nginx .")
                //         customImage.push()
                //     }
                // }
                sh 'docker build -t mynginx:latest -f /home/ubuntu/Dockerfile.nginx || true'
            }
        }

        stage('Deploy to Nginx Container') {
            steps {
                // Stop and remove the existing Nginx container
                sh 'docker stop mynginx || true'
                sh 'docker rm mynginx || true'

                // Deploy the newly built custom Nginx Docker image as an Nginx container
                sh "docker run -d -p 81:80 --name mynginx ${DOCKER_IMAGE}:${DOCKER_TAG}"
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
