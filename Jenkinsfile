pipeline {
agent any

environment {
    DOCKER_USER = "preethibino"
    IMAGE_NAME = "ecommerce-app"
}

stages {

    stage('Checkout Code') {
        steps {
            checkout scm
        }
    }

    stage('Show Branch') {
        steps {
            echo "Building branch: ${env.BRANCH_NAME}"
        }
    }

    stage('Build Docker Image') {
        steps {
            sh '''
            docker build -t $DOCKER_USER/$IMAGE_NAME:latest .
            '''
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

    stage('Push to DEV Repo') {
        when {
            branch 'dev'
        }
        steps {
            sh '''
            docker tag $DOCKER_USER/$IMAGE_NAME:latest $DOCKER_USER/ecommerce-dev:latest
            docker push $DOCKER_USER/ecommerce-dev:latest
            '''
        }
    }

    stage('Push to PROD Repo') {
        when {
            branch 'master'
        }
        steps {
            sh '''
            docker tag $DOCKER_USER/$IMAGE_NAME:latest $DOCKER_USER/ecommerce-prod:latest
            docker push $DOCKER_USER/ecommerce-prod:latest
            '''
        }
    }

    stage('Deploy Container on Port 80') {
        steps {
            sh '''
            docker stop ecommerce-container || true
            docker rm ecommerce-container || true

            docker run -d \
              --name ecommerce-container \
              -p 80:80 \
              $DOCKER_USER/$IMAGE_NAME:latest
            '''
        }
    }
}


}
