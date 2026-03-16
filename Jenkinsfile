pipeline {
agent any


environment {
    DOCKER_USER = "preethibino"
    IMAGE_NAME  = "ecommerce-app"
}

stages {

    stage('Checkout Code') {
        steps {
            checkout scm
        }
    }

    stage('Build Docker Image') {
        steps {
            sh 'docker build -t $DOCKER_USER/$IMAGE_NAME:latest .'
        }
    }

    // YOUR EXISTING LOGIN (UNCHANGED)
    stage('Login to Docker Hub') {
        steps {
            withCredentials([string(credentialsId: 'docker-pass', variable: 'DOCKER_PASS')]) {
                sh '''
                echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                '''
            }
        }
    }

    // 🔥 ALWAYS RUNS — NO SKIP ISSUE
    stage('Tag & Push Image') {
        steps {
            sh '''
            echo "Current branch: $BRANCH_NAME"

            if [ "$BRANCH_NAME" = "master" ]; then
                TARGET="$DOCKER_USER/guvifinalproject-prod:latest"
            else
                TARGET="$DOCKER_USER/guvifinalproject-dev:latest"
            fi

            echo "Pushing image to $TARGET"

            docker tag $DOCKER_USER/$IMAGE_NAME:latest $TARGET
            docker push $TARGET
            '''
        }
    }

    stage('Deploy Container on Port 80') {
        steps {
            sh '''
            docker stop ecommerce-container || true
            docker rm ecommerce-container || true

            if [ "$BRANCH_NAME" = "master" ]; then
                IMAGE="$DOCKER_USER/guvifinalproject-prod:latest"
            else
                IMAGE="$DOCKER_USER/guvifinalproject-dev:latest"
            fi

            docker run -d \
              --name ecommerce-container \
              -p 80:80 \
              $IMAGE
            '''
        }
    }
}

}
