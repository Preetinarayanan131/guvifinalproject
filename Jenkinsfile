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
    stage('Determine Branch') {
    steps {
        script {
            // Get current branch from Git
            // Use Jenkins-provided environment variable
            BRANCH_NAME = env.GIT_BRANCH
            echo "Current branch detected: ${BRANCH_NAME}"
        }
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

    //  ALWAYS RUNS — NO SKIP ISSUE
    stage('Tag & Push Image') {
        steps {
	  
          script{
	    // Capture branch name in shell
            def branch = BRANCH_NAME.replaceFirst('origin/', '')
            echo "Using branch: ${branch}"

            sh """
            if [ "${branch}" = "master" ]; then
                TARGET="$DOCKER_USER/guvifinalproject-prod:latest"
            else
                TARGET="$DOCKER_USER/guvifinalproject-dev:latest"
            fi

            echo "Pushing image to $TARGET"
            docker tag $DOCKER_USER/$IMAGE_NAME:latest $TARGET
            docker push $TARGET
            """
	     }
        }
    }

    stage('Deploy Container on Port 80') {
        steps {

	    def branch = BRANCH_NAME.replaceFirst('origin/', '')
            def IMAGE = branch == 'master' ? "${DOCKER_USER}/guvifinalproject-prod:latest" : "${DOCKER_USER}/guvifinalproject-dev:latest"
            sh """
            docker stop ecommerce-container || true
            docker rm ecommerce-container || true
            docker run -d --name ecommerce-container -p 80:80 $IMAGE
            """
        }
    }
}

}
