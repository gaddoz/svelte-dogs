pipeline {

  agent any

  tools {nodejs "node_v17"}

  environment {
      tagName = "svelte-dogs-${GIT_BRANCH}";
  }

  stages {

    stage('SCM Check for changes') {
      steps {
        scmSkip(deleteBuild: true, skipPattern:'.*\\[ci skip\\].*')
      }
    }

    stage('Docker Build') {
      steps {
        sh "docker build -t ${tagName} . "
      }
    }

    stage('E2E Test') {
      steps {
        sh "docker-compose up --abort-on-container-exit --exit-code-from cypress"
        sh "cat e2e-tests/cypress/results/output.xml"
      }
    }

    stage('Docker Tag & Push') {

      steps {
        sh "docker tag ${tagName} registry:5000/${tagName}";
        sh "docker push registry:5000/${tagName}";
      }
    }

  }
  post {
    success {
      withCredentials([usernamePassword(credentialsId: "TELEGRAM_BOT", usernameVariable: 'CHAT_ID', passwordVariable: 'PASSWORD')]) {
        sh script: $/
          curl -X POST \
            -H 'Content-Type: application/json' \
            -d '{"chat_id": "'$CHAT_ID'", \
            "text": "❎ Jenkins\n job: '$JOB_BASE_NAME' result: SUCCESS!", "disable_notification": false}' \
            https://api.telegram.org/bot{$PASSWORD}/sendMessage
        /$
      }
    }
    failure {
      withCredentials([usernamePassword(credentialsId: "TELEGRAM_BOT", usernameVariable: 'CHAT_ID', passwordVariable: 'PASSWORD')]) {
        sh script: $/
          curl -X POST \
            -H 'Content-Type: application/json' \
            -d '{"chat_id": "'$CHAT_ID'", \
            "text": "❌ Jenkins\n job: '$JOB_BASE_NAME' result: FAILED! '$FAILED_STAGE' '$FAILED_MESSAGE'", "disable_notification": false}' \
            https://api.telegram.org/bot{$PASSWORD}/sendMessage
        /$
      }
    }
  }
}
