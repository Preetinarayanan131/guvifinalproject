pipeline {
    agent any

    environment {
        DOCKER_USER = "preethibino"
        DEV_REPO = "guvifinalproject-dev"
        IMAGE_NAME = "latest"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'dev',
                url: 'https://github.com/Preetinarayanan131/guvifinalproject.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME:latest .'
            }
        }

        stage('Tag Image for DEV Repo') {
            steps {
                sh 'docker tag $IMAGE_NAME:latest $DOCKER_USER/$DEV_REPO:latest'
            }
        }

        stage('Push to Docker Hub DEV Repo') {
    	   steps {
	        withCredentials([usernamePassword(
                credentialsId: 'dockerhub-cred',
                usernameVariable: 'DOCKER_USER',
                passwordVariable: 'DOCKER_PASS'
            )]) {
            	sh '''
            	echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
            	docker push preethibino/guvifinalproject-dev:latest
            	'''
              }
          }
       }

        stage('Deploy Container') {
            steps {
                sh '''
                docker stop dev-container || true
                docker rm dev-container || true
                docker run -d -p 80:80 --name dev-container $DOCKER_USER/$DEV_REPO:latest
                '''
            }
        }
    }
}
