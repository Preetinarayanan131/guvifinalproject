pipeline {
    agent any

    environment {
        DOCKER_USER = "preethibino"
        DEV_REPO = "guvifinalproject-dev"
        PROD_REPO = "guvifinalproject-prod"
        IMAGE_NAME = "guvifinalproject"
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
                script {
                    sh "docker build -t ${IMAGE_NAME}:latest ."
                }
            }
        }

        stage('Tag Image') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'dev') {
                        sh "docker tag ${IMAGE_NAME}:latest ${DOCKER_USER}/${DEV_REPO}:latest"
                    } else if (env.BRANCH_NAME == 'master') {
                        sh "docker tag ${IMAGE_NAME}:latest ${DOCKER_USER}/${PROD_REPO}:latest"
                    }
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-cred',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    script {
                        sh '''
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                        '''
                        if (env.BRANCH_NAME == 'dev') {
                            sh "docker push ${DOCKER_USER}/${DEV_REPO}:latest"
                        } else if (env.BRANCH_NAME == 'master') {
                            sh "docker push ${DOCKER_USER}/${PROD_REPO}:latest"
                        }
                    }
                }
            }
        }

        stage('Deploy Container') {
            steps {
                script {
                    def repoToDeploy = (env.BRANCH_NAME == 'dev') ? "${DOCKER_USER}/${DEV_REPO}:latest" : "${DOCKER_USER}/${PROD_REPO}:latest"
                    sh """
                    docker stop dev-container || true
                    docker rm dev-container || true
                    docker run -d -p 80:80 --name dev-container $repoToDeploy
                    """
                }
            }
        }
    }

    triggers {
        // GitHub webhook trigger
        githubPush()
    }
}