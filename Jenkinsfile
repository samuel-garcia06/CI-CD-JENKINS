pipeline {
  agent any

  environment {
    IMAGE_NAME = "samuelgarciaayala/angular-jenkins"
    REMOTE_APP_DIR = "/opt/angular-jenkins"
    CURRENT_STAGE = "Inicializacion"
    RESOLVED_TAG = ""
    DEFAULT_EMAIL_TO = "samuelgarciaayala@gmail.com"
  }

  options {
    timestamps()
    disableConcurrentBuilds()
    buildDiscarder(logRotator(numToKeepStr: '20'))
  }

  parameters {
    choice(name: 'DEPLOY_ENV', choices: ['staging', 'production'], description: 'Entorno objetivo para el despliegue.')
    string(name: 'IMAGE_TAG', defaultValue: '', description: 'Tag manual opcional. Si se deja vacio se usa el numero de build.')
    string(name: 'APP_URL', defaultValue: 'http://217.182.204.183:8080', description: 'URL publica para las pruebas post-despliegue.')
    string(name: 'POST_DEPLOY_JOB', defaultValue: '', description: 'Job downstream opcional para verificacion o monitorizacion.')
    string(name: 'EMAIL_TO', defaultValue: 'samuelgarciaayala@gmail.com', description: 'Correo destinatario para notificaciones de Jenkins.')
    booleanParam(name: 'PUSH_IMAGES', defaultValue: false, description: 'Publicar imagenes en Docker Hub.')
    booleanParam(name: 'DEPLOY_AFTER_BUILD', defaultValue: true, description: 'Desplegar automaticamente tras crear las imagenes.')
  }

  triggers {
    githubPush()
    cron('H 3 * * 1-5')
    upstream(upstreamProjects: 'angular-jenkins-seed', threshold: hudson.model.Result.SUCCESS)
  }

  stages {
    stage('Checkout') {
      steps {
        script { env.CURRENT_STAGE = 'Checkout' }
        deleteDir()
        checkout scm
      }
    }

    stage('Install') {
      steps {
        script { env.CURRENT_STAGE = 'Install' }
        sh 'npm ci'
      }
    }

    stage('Static Analysis') {
      steps {
        script { env.CURRENT_STAGE = 'Static Analysis' }
        sh 'npm run lint'
      }
    }

    stage('Unit Tests') {
      steps {
        script { env.CURRENT_STAGE = 'Unit Tests' }
        sh 'CHROME_BIN=/usr/bin/google-chrome npm run test:ci'
      }
      post {
        always {
          archiveArtifacts artifacts: 'coverage/**', allowEmptyArchive: true
        }
      }
    }

    stage('Build Angular') {
      steps {
        script { env.CURRENT_STAGE = 'Build Angular' }
        sh 'npm run build'
        sh '''
          mkdir -p artifacts
          tar -czf artifacts/angular-frontend.tar.gz dist docker-compose.yml nginx.conf deploy scripts
        '''
      }
      post {
        success {
          archiveArtifacts artifacts: 'artifacts/*.tar.gz,dist/**', allowEmptyArchive: false
        }
      }
    }

    stage('Build Docker Images') {
      steps {
        script {
          env.CURRENT_STAGE = 'Build Docker Images'
          env.RESOLVED_TAG = params.IMAGE_TAG?.trim() ? params.IMAGE_TAG.trim() : env.BUILD_NUMBER
        }
        sh '''
          docker build -f Dockerfile.alpine \
            -t ${IMAGE_NAME}:alpine-latest \
            -t ${IMAGE_NAME}:alpine-${RESOLVED_TAG} .
          docker build -f Dockerfile.debian \
            -t ${IMAGE_NAME}:debian-latest \
            -t ${IMAGE_NAME}:debian-${RESOLVED_TAG} .
        '''
      }
    }

    stage('Push Docker Images') {
      when {
        expression { return params.PUSH_IMAGES }
      }
      steps {
        script { env.CURRENT_STAGE = 'Push Docker Images' }
        withCredentials([usernamePassword(credentialsId: 'DOCKER_CREDS', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
          sh 'echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin'
          sh '''
            docker push ${IMAGE_NAME}:alpine-latest
            docker push ${IMAGE_NAME}:alpine-${RESOLVED_TAG}
            docker push ${IMAGE_NAME}:debian-latest
            docker push ${IMAGE_NAME}:debian-${RESOLVED_TAG}
          '''
        }
      }
    }

    stage('Deploy') {
      when {
        expression { return params.DEPLOY_AFTER_BUILD }
      }
      steps {
        script { env.CURRENT_STAGE = 'Deploy' }
        sh '''
          mkdir -p ${REMOTE_APP_DIR}/deploy ${REMOTE_APP_DIR}/scripts/ci
          cp docker-compose.yml ${REMOTE_APP_DIR}/docker-compose.yml
          cp deploy/remote-deploy.sh ${REMOTE_APP_DIR}/deploy/remote-deploy.sh
          cp scripts/ci/post-deploy-check.sh ${REMOTE_APP_DIR}/scripts/ci/post-deploy-check.sh
          chmod +x ${REMOTE_APP_DIR}/deploy/remote-deploy.sh ${REMOTE_APP_DIR}/scripts/ci/post-deploy-check.sh
          IMAGE_NAME=${IMAGE_NAME}:alpine-${RESOLVED_TAG} \
          REMOTE_APP_DIR=${REMOTE_APP_DIR} \
          APP_ENV=${params.DEPLOY_ENV} \
          APP_PORT=8080 \
          SKIP_PULL=1 \
          ${REMOTE_APP_DIR}/deploy/remote-deploy.sh
        '''
      }
    }

    stage('Post-Deploy Checks') {
      when {
        expression { return params.DEPLOY_AFTER_BUILD }
      }
      steps {
        script { env.CURRENT_STAGE = 'Post-Deploy Checks' }
        sh 'APP_URL=${APP_URL} bash scripts/ci/post-deploy-check.sh'
      }
      post {
        always {
          archiveArtifacts artifacts: 'reports/**', allowEmptyArchive: true
        }
      }
    }

    stage('Trigger Downstream Job') {
      when {
        expression { return params.POST_DEPLOY_JOB?.trim() }
      }
      steps {
        script { env.CURRENT_STAGE = 'Trigger Downstream Job' }
        build job: params.POST_DEPLOY_JOB.trim(),
          wait: true,
          parameters: [
            string(name: 'APP_URL', value: params.APP_URL),
            string(name: 'DEPLOY_ENV', value: params.DEPLOY_ENV),
            string(name: 'IMAGE_TAG', value: env.RESOLVED_TAG)
          ]
      }
    }
  }

  post {
    success {
      emailext(
        to: params.EMAIL_TO?.trim() ? params.EMAIL_TO.trim() : env.DEFAULT_EMAIL_TO,
        subject: "Jenkins OK: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
        body: """La ejecucion ha finalizado correctamente.

Entorno: ${params.DEPLOY_ENV}
Tag generado: ${env.RESOLVED_TAG ?: env.BUILD_NUMBER}
URL verificada: ${params.APP_URL}
Consola: ${env.BUILD_URL}console
"""
      )
    }
    failure {
      emailext(
        to: params.EMAIL_TO?.trim() ? params.EMAIL_TO.trim() : env.DEFAULT_EMAIL_TO,
        subject: "Jenkins ERROR: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
        body: """La ejecucion ha fallado.

Ultima fase registrada: ${env.CURRENT_STAGE}
Entorno: ${params.DEPLOY_ENV}
Consola: ${env.BUILD_URL}console
"""
      )
    }
    always {
      sh 'docker logout || true'
    }
  }
}
