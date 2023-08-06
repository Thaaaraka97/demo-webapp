pipeline {
    agent any

    environment {
        // Define the Docker image name and tag
        DOCKER_IMAGE = "thaaaraka/custom_nginx_for_webapp" // Use the custom Nginx Docker image name
        DOCKER_TAG = "latest"
        DOCKERHUB_CREDENTIALS = credentials('docker-hub-credentials')

        SSH_CREDENTIALS = credentials('test')
        SSH_PRIVATE_KEY = SSH_CREDENTIALS_USR_PRIVATE_KEY
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

                
                sh 'docker build -t thaaaraka/custom_nginx_for_webapp:latest .'
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                sh 'docker push thaaaraka/custom_nginx_for_webapp:latest'
                sh 'docker logout'
                
            }
        }

        stage('Deploy to Nginx Container') {
            // steps {
            //     // Stop and remove the existing Nginx container
            //     sh 'docker stop custom_nginx_for_webapp || true'
            //     sh 'docker rm custom_nginx_for_webapp || true'

            //     // Deploy the newly built custom Nginx Docker image as an Nginx container
            //     sh "docker run -d -p 81:80 --name custom_nginx_for_webapp ${DOCKER_IMAGE}:${DOCKER_TAG}"
            // }
            steps {
                // SSH into the target VM and deploy the Nginx container                
                

                

                // sh 'ssh -i .ssh/id_rsa 10.0.30.43'
                // sh 'sudo docker stop mynginx || true'
                // sh 'sudo docker rm mynginx || true'
                // sh 'sudo docker pull ${DOCKER_IMAGE}:${DOCKER_TAG}'
                // sh 'sudo docker run -d -p 81:80 --name mynginx ${DOCKER_IMAGE}:${DOCKER_TAG}'

                sh '''
                    ssh -o StrictHostKeyChecking=no -i "$SSH_PRIVATE_KEY" ubuntu@10.0.18.137 'echo Hello from the remote machine'
                '''

                
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
