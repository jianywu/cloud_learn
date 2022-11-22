pipeline {
  agent any
  environment {
    NAME='user1'
    PASSWD='123456'
  }
  stages {
    stage('env stage1') {
      environment {
        GIT_SERVER = 'git clone git@114.115.144.163:test/test.git'
      }
      steps {
        sh """
            echo '$NAME'
            echo '$PASSWD'
            echo '$GIT_SERVER'
        """
      }
    }
    stage('env stage2') {
      steps {
        sh """
            echo '${NAME}'
            echo '$PASSWD'
        """
      }
    }
  }
}
