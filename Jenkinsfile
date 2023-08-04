pipeline {
    agent any

    environment {
        // Define the Docker image name and tag
        DOCKER_IMAGE = "custom_nginx_for_webapp" // Use the custom Nginx Docker image name
        DOCKER_TAG = "latest"
        DOCKERHUB_CREDENTIALS = credentials('docker-hub-credentials')
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
                //     docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-credentials') {
                //         def customImage = docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}", " .")
                //         customImage.push()
                //     }
                // }

                
                sh 'docker build -t mynginx:latest .'
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                sh 'docker push mynginx:latest'
                
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
        sh 'docker logout'
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Deployment failed!'
        }
    }
}
