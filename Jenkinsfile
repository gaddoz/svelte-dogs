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
        withCredentials([usernamePassword(credentialsId: "TELEGRAM_BOT", usernameVariable: 'TG_CHAT_ID', passwordVariable: 'TG_BOT_TOKEN')]) {

          sh 'echo will send a video for each video in /e2e-tests/cypress/videos'
          sh '''
            find e2e-tests/cypress/videos -type f | xargs -I filename curl -L -X POST https://api.telegram.org/bot$TG_BOT_TOKEN/sendVideo \
              -H 'Content-Type: multipart/form-data' \
              -H 'Accept: application/json' \
              -F 'chat_id="'$TG_CHAT_ID'"' \
              -F 'video=@"'$PWD'/filename"' \
              -F 'caption="filename"'
          '''

          sh 'echo will send a picture for each screenshot in /e2e-tests/cypress/screenshots'
          sh '''
            find e2e-tests/cypress/screenshots -type f | xargs -I filename curl -L -X POST https://api.telegram.org/bot$TG_BOT_TOKEN/sendPhoto \
              -H 'Content-Type: multipart/form-data' \
              -H 'Accept: application/json' \
              -F 'chat_id="'$TG_CHAT_ID'"' \
              -F 'photo=@"'$PWD'/filename"' \
              -F 'caption="filename"'
          '''

        }
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
      withCredentials([usernamePassword(credentialsId: "TELEGRAM_BOT", usernameVariable: 'TG_CHAT_ID', passwordVariable: 'TG_BOT_TOKEN')]) {
        sh script: $/
          curl -X POST \
            -H 'Content-Type: application/json' \
            -d '{"chat_id": "'$TG_CHAT_ID'", \
            "text": "🟢 Jenkins\n job: '$JOB_BASE_NAME' result: SUCCESS!", "disable_notification": false}' \
            https://api.telegram.org/bot{$TG_BOT_TOKEN}/sendMessage
        /$
      }
    }
    failure {
      withCredentials([usernamePassword(credentialsId: "TELEGRAM_BOT", usernameVariable: 'TG_CHAT_ID', passwordVariable: 'TG_BOT_TOKEN')]) {
        sh script: $/
          curl -X POST \
            -H 'Content-Type: application/json' \
            -d '{"chat_id": "'$TG_CHAT_ID'", \
            "text": "🔴 Jenkins\n job: '$JOB_BASE_NAME' result: FAILED! '$FAILED_STAGE' '$FAILED_MESSAGE'", "disable_notification": false}' \
            https://api.telegram.org/bot{$TG_BOT_TOKEN}/sendMessage
        /$
      }
    }
  }
}
