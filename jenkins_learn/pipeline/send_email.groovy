pipeline {
  agent any
  stages {
    stage('post test -code clone stage') {
        steps {
            sh 'echo git clone'
            sh 'cd /data/xxx'  // Trigger manual fail, to send email
        }
        post {
            cleanup {
                script {
                  mail to: '332348328@qq.com',
                  subject: "Pipeline Name: ${currentBuild.fullDisplayName}",
                  body: " ${env.JOB_NAME} -Build Number-${env.BUILD_NUMBER} -cleanup build failed!\n click link ${env.BUILD_URL} to see details"
                }
            }
            always {
                    script {
                  mail to: '332348328@qq.com',
                  subject: "Pipeline Name: ${currentBuild.fullDisplayName}",
                  body: " ${env.JOB_NAME} -Build Number-${env.BUILD_NUMBER} -always build failed!\n click link ${env.BUILD_URL} to see details"
                    }
            }
            aborted {
                    echo "post aborted"
            }
            success {
                script {
                mail to: '332348328@qq.com',
                    subject: "Pipeline Name: ${currentBuild.fullDisplayName}",
                    body: " ${env.JOB_NAME} -Build Number-${env.BUILD_NUMBER} - build successful!\n click link ${env.BUILD_URL} to see details"
                }
            }
            failure {
                script {
                mail to: '332348328@qq.com',
                    subject: "Pipeline Name: ${currentBuild.fullDisplayName}",
                    body: " ${env.JOB_NAME} -Build Number-${env.BUILD_NUMBER} -failure build failed!\n click link ${env.BUILD_URL} to see details"
                }
            }

        }
    }
  }
}
