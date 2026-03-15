pipeline {
    agent any

    environment {
        DOCKER_USER = "preethibino"
        DEV_REPO = "guvifinalproject-dev"
        PROD_REPO = "guvifinalproject-prod"
        IMAGE_NAME = "guvifinalproject"
        
        EC2_USER = "ec2-user"
        EC2_HOST = "18.205.7.220"
        EC2_KEY = "/var/jenkins_home/keys/15mar.pem" // Update with Jenkins path to your .pem file
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: "${env.BRANCH_NAME}",
                    url: 'https://github.com/Preetinarayanan131/guvifinalproject.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t $IMAGE_NAME:latest ."
            }
        }

        stage('Tag Image') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'dev') {
                        sh "docker tag $IMAGE_NAME:latest $DOCKER_USER/$DEV_REPO:latest"
                    } else if (env.BRANCH_NAME == 'master') {
                        sh "docker tag $IMAGE_NAME:latest $DOCKER_USER/$PROD_REPO:latest"
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-cred', // Jenkins Docker Hub credentials ID
                    usernameVariable: 'DOCKER_HUB_USER',
                    passwordVariable: 'DOCKER_HUB_PASS'
                )]) {
                    script {
                        sh """
                        echo $DOCKER_HUB_PASS | docker login -u $DOCKER_HUB_USER --password-stdin
                        """
                        if (env.BRANCH_NAME == 'dev') {
                            sh "docker push $DOCKER_USER/$DEV_REPO:latest"
                        } else if (env.BRANCH_NAME == 'master') {
                            sh "docker push $DOCKER_USER/$PROD_REPO:latest"
                        }
                    }
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                script {
                    def IMAGE_TO_DEPLOY = (env.BRANCH_NAME == 'dev') ? "$DOCKER_USER/$DEV_REPO:latest" : "$DOCKER_USER/$PROD_REPO:latest"
                    sh """
                    ssh -o StrictHostKeyChecking=no -i $EC2_KEY $EC2_USER@$EC2_HOST \\
                    'docker stop app-container || true && \\
                     docker rm app-container || true && \\
                     docker pull $IMAGE_TO_DEPLOY && \\
                     docker run -d -p 80:80 --name app-container $IMAGE_TO_DEPLOY'
                    """
                }
            }
        }
    }

    post {
        always {
            echo "Build finished for branch ${env.BRANCH_NAME}"
        }
        failure {
            echo "Build failed for branch ${env.BRANCH_NAME}"
        }
    }
}