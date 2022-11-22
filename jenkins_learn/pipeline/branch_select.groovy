// Note: first time failure is normal, because branch info is not there.
pipeline {
  agent any
  parameters {
    string(name: 'BRANCH', defaultValue:  'develop', description: 'select branch')
    choice(name: 'DEPLOY_ENV', choices: ['develop', 'production'], description: 'select deploy env')
  }
  stages {
    stage('param1') {
      steps {
        sh "echo $BRANCH"
      }
    }
    stage('param2') {
      steps {
        sh "echo $DEPLOY_ENV"
      }
    }
  }
}
