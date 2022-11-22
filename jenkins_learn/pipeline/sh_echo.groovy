pipeline {
  agent any
  stages {
    stage('code clone'){
      agent any
        steps{
            sh 'echo code clone'
        }
    }
    stage('code deploy'){
      agent any
        steps{
            sh 'echo code deploy'
        }
    }
    stage('image update'){
      agent any
        steps{
            sh 'echo image update'
        }
    }
  }
}
