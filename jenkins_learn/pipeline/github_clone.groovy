pipeline{
    agent { label 'jenkins-node1' }
    stages{
        stage("code clone"){
            steps{
                sh """
                  mkdir -p /var/lib/jenkins/workspace/pipline-test1
                  cd /var/lib/jenkins/workspace/pipline-test1 && rm -rf ./*
                  git clone git@114.115.144.163:test/test.git
                  echo code clone done
                """
            }
        }

        stage("code deploy"){
                steps{
                    sh "tar czvf frontend.tar.gz --exclude=.git --exclude=.gitignore  --exclude=README.md ./"
                }
        }
    }
}
