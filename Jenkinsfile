pipeline {
  agent any

  environment {
    DOCKER_IMAGE_SCOPE = 'scubakay'
    DOCKER_IMAGE_NAME = 'automated_nginx_demo'
    DOCKER_IMAGE_VERSION = 'latest'
  }

  stages {
    stage('Build') {
      agent {
        dockerfile {
          filename 'Dockerfile.build'
          args '-v build:/usr/src/app/dist/automated-nginx-demo'
        }
      }
      steps {
        sh 'cd ~/ && ls -al'
        stash includes: 'build/**/*', name: 'build'
      }
    }

    stage('Containerize') {
      steps {
        unstash 'build'
        sh 'docker build -f "Dockerfile.production" -t ${DOCKER_IMAGE_SCOPE}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION} .'
      }
    }

    stage('Deploy') {
      steps {
        sh 'docker-compose up -d'
      }
    }
  }
}
