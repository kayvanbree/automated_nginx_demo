pipeline {
  agent any

  environment {
    DOCKER_IMAGE_SCOPE = 'scubakay'
    DOCKER_IMAGE_NAME = 'automated_nginx_demo'
    DOMAIN = "${env.BRANCH_NAME + '.dev.scubakay.com'}"
  }

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
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'dockerhub_p', usernameVariable: 'dockerhub_u')]) {
          unstash 'dist'
          sh 'docker build -t ${DOCKER_IMAGE_SCOPE}/${DOCKER_IMAGE_NAME}:${BRANCH_NAME} .'
          sh 'docker login -u ${dockerhub_u} -p ${dockerhub_p}'
          sh 'docker push ${DOCKER_IMAGE_SCOPE}/${DOCKER_IMAGE_NAME}:${BRANCH_NAME}'
        }
      }
    }

    stage('Deploy master') {
      when { branch 'master' }
      environment {
        DOMAIN = 'dev.scubakay.com'
      }
      steps {
        script {
          sh 'echo "Deploying to ${DOMAIN}"...'
          sh 'docker-compose down --rmi all'
          sh 'docker-compose pull'
          sh 'docker-compose config'
          sh 'docker-compose up -d'
        }
      }
    }

    stage('Deploy branch') {
      when {
        not { branch 'master' }
      }
      steps {
        script {
          sh 'echo "Deploying to ${DOMAIN}"...'
          sh 'docker-compose down --rmi all'
          sh 'docker-compose pull'
          sh 'docker-compose config'
          sh 'docker-compose up -d'
        }
      }
    }
  }
}
