pipeline {
  agent {
    docker {
      image 'mhart/alpine-node:10'
      args '-u root:root'
    }
  }

  stages {
    stage('Fetch dependencies') {
      steps {
        sh 'npm install'
        stash includes: 'node_modules/', name: 'node_modules'
      }
    }

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
      steps {
        unstash 'node_modules'
        sh 'npm run build'
        stash includes: 'dist/', name: 'dist'
      }
    }

    stage('Build and Push Docker Image') {
      agent {
        label "master"
      }
      environment {
        DOCKER_IMAGE_SCOPE = 'scubakay'
        DOCKER_IMAGE_NAME = 'automated_nginx_demo'
        DOCKER_IMAGE_VERSION = 'latest'
      }
      steps {
        unstash 'dist'
        sh 'docker build -t ${DOCKER_IMAGE_SCOPE}/${DOCKER_IMAGE_NAME}:${BRANCH_NAME} .'

        // sh 'docker login -u $DOCKER_PUSH_USR -p $DOCKER_PUSH_PSW $DOCKER_PUSH_URL'
        // sh 'docker push $DOCKER_PUSH_URL/frontend'
      }
    }

    stage('Deploy') {
      agent {
        label "master"
      }
      steps {
        sh 'docker-compose up -d'
      }
    }
  }
}
