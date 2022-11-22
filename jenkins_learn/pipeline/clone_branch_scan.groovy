pipeline {
  agent { label 'jenkins-node1' }
  parameters {
    string(name: 'BRANCH', defaultValue:  'develop', description: 'select branch')
    choice(name: 'DEPLOY_ENV', choices: ['develop', 'production'], description: 'select deploy env')
  }
  stages {
    stage('var test1') {
      steps {
        sh "echo $env.WORKSPACE"
        sh "echo $env.JOB_URL"
        sh "echo $env.NODE_NAME"
        sh "echo $env.NODE_LABELS"
        sh "echo $env.JENKINS_URL"
        sh "echo $env.JENKINS_HOME"
      }
    }
    stage("code clone"){
            steps {
                deleteDir()
                script {
                    if (env.BRANCH == 'main') {
                      sh "git clone -b main git@114.115.144.163:test/test.git"
                    } else if (env.BRANCH == 'develop') {
                      sh "git clone -b develop git@114.115.144.163:test/test.git"
                    } else {
                        echo 'BRANCH PARAMETER ERROR'
                    }
                    GIT_COMMIT_TAG = sh "cd test;git rev-parse --short HEAD"
                }
            }
    }
  }
  stage('python source code scan') {
        steps {
            sh "cd $env.WORKSPACE && /apps/sonar-scanner/bin/sonar-scanner -Dsonar.projectKey=magedu -Dsonar.projectName=magedu-python-app1 -Dsonar.projectVersion=1.0  -Dsonar.sources=./src -Dsonar.language=py -Dsonar.sourceEncoding=UTF-8"
        }
  }
}

