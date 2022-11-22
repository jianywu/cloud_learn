# need click in console for yes, when continue appears.
# usually click for deploy to customer ENV.
pipeline {
  agent any
  stages {
    stage('inter-active') {
      input {
        message "continue?"
        ok "yes"
        submitter "jenkinsadmin"
      }
      steps {
        echo "Hello jenkins!"
      }
    }
  }
}
