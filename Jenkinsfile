pipeline {
  agent any

  stages {
    //stage('Fetch dependencies') {
    //  agent {
    //    docker {
    //      image 'mhart/alpine-node:10'
    //      args '-u root:root'
    //    }
    //  }
    //  steps {
    //    sh 'npm install'
    //    stash includes: 'node_modules/', name: 'node_modules'
    //  }
    //}

    //stage('Unit Test') {
    //  agent {
    //    docker 'weboaks/node-karma-protractor-chrome'
    //  }
    //  steps {
    //    unstash 'node_modules'
    //    sh 'npm run test:ci'
    //    junit 'reports/**/*.xml'
    //  }
    //}

    stage('Compile') {
      agent {
        docker {
          image 'mhart/alpine-node:10'
          args '-u root:root'
        }
      }
      steps {
        // unstash 'node_modules'
        sh 'npm install'
        sh 'npm run build'
        stash includes: 'dist/', name: 'dist'
      }
    }

    stage('Build and Push Docker Image') {
      environment {
        DOCKER_IMAGE_SCOPE = 'scubakay'
        DOCKER_IMAGE_NAME = 'automated_nginx_demo'
        DOCKER_IMAGE_VERSION = 'latest'
      }
      steps {
        unstash 'dist'
        withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'dockerhub_p', usernameVariable: 'dockerhub_u')]) {
          sh 'docker build -t ${DOCKER_IMAGE_SCOPE}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION} .'
          sh 'docker login -u ${dockerhub_u} -p ${dockerhub_p}'
          sh 'docker push ${DOCKER_IMAGE_SCOPE}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION}'
        }
      }
    }

    stage('Deploy') {
      steps {
        sh 'docker-compose up -d --verbose'
      }
    }
  }
}
