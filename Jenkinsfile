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
	  // Normalize branch
            def branch = BRANCH_NAME.replaceFirst('origin/', '')
            echo "Using branch: ${branch}"

            // Decide target repo
            def targetRepo = branch == 'master' ? "${DOCKER_USER}/guvifinalproject-prod:latest" : "${DOCKER_USER}/guvifinalproject-dev:latest"
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
	 
	  script{
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
