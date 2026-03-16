pipeline {
    agent any

    environment {
        DOCKER_USER = "preethibino"
        IMAGE_NAME  = "ecommerce-app"
	GITHUB_CRED  = "github-pass"
    }

    stages {

        stage('Checkout Code') {
            steps {
                checkout([$class: 'GitSCM',
                    branches: [[name: env.BRANCH_NAME]],
                    userRemoteConfigs: [[
                        url: 'https://github.com/Preetinarayanan131/guvifinalproject.git',
                        credentialsId: "${GITHUB_CRED}"
                    ]]
                ])
            }
        }

        stage('Determine Branch') {
            steps {
                script {
                   echo "Current branch: ${env.BRANCH_NAME}"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKER_USER/$IMAGE_NAME:latest .'
            }
        }

        stage('Login to Docker Hub') {
            steps {
                withCredentials([string(credentialsId: 'docker-pass', variable: 'DOCKER_PASS')]) {
                    sh '''
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    '''
                }
            }
        }

        stage('Tag & Push Image') {
            steps {
                script {
                    echo "Using branch: ${BRANCH_NAME}"

                    // Decide target repo based on branch
                    def targetRepo = env.BRANCH_NAME == 'master' ? "${DOCKER_USER}/guvifinalproject-prod:latest" : "${DOCKER_USER}/guvifinalproject-dev:latest"
                    echo "Pushing image to ${targetRepo}"

                    sh """
                    docker tag $DOCKER_USER/$IMAGE_NAME:latest $targetRepo
                    docker push $targetRepo
                    """
                }
            }
        }

        stage('Deploy Container on Port 80') {
            steps {
                script {
                    def IMAGE = env.BRANCH_NAME == 'master' ? "${DOCKER_USER}/guvifinalproject-prod:latest" : "${DOCKER_USER}/guvifinalproject-dev:latest"

                    sh """
                    docker stop ecommerce-container || true
                    docker rm ecommerce-container || true
                    docker run -d --name ecommerce-container -p 80:80 $IMAGE
                    """
                }
            }
        }
    }
}