#!groovy
pipeline {
    agent any  // global must configure agent.
    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
        disableConcurrentBuilds()
    }
    environment {
        def NODE_1 = "114.115.154.84"
        def NODE_3 = "114.115.144.163"
        def APP1_DEPLOY_DIR = '/var/lib/jenkins/workspace/magedu-app1_deploy-20221120'
        def TEST_GIT_URL = 'git@114.115.144.163:user3/test.git'
        def WEB_GIT_URL = 'git@114.115.144.163:user3/web_test.git'
        def SONAR_GIT_URL = 'git@114.115.144.163:user3/sonar_python_scan.git'
        def HARBOR_URL = 'harbor.magedu.net'
        def IMAGE_PROJECT = 'myserver'
        def IMAGE_NAME = 'nginx'
        def DATE = sh(script:'date +%F_%H-%M-%S', returnStdout: true).trim()
    }

    parameters {
        string(name: 'BRANCH', defaultValue:  'main', description: 'branch select') // string param
        choice(name: 'DEPLOY_ENV', choices: ['develop', 'production'], description: 'deploy env')  // option param
    }

    stages {
        stage('code clone') {
            agent { label 'jenkins-node1' }  // not mandatory to configure in stage
            steps {
                sh "rm -rf '/var/lib/jenkins/workspace/magedu-app1_deploy-20221120';mkdir -p '/var/lib/jenkins/workspace/magedu-app1_deploy-20221120'"
                dir('/var/lib/jenkins/workspace/magedu-app1_deploy-20221120') {
                    script {
                        if (env.BRANCH == 'main') {
                            sh "git clone -b main ${env.TEST_GIT_URL}"
                            sh "git clone -b main ${env.SONAR_GIT_URL}"
                            sh "git clone -b main ${env.WEB_GIT_URL}"
                        } else if (env.BRANCH == 'develop') {
                            sh 'git clone -b develop git@114.115.144.163:test/test.git'
                        } else {
                            echo 'BRANCH PARAMETER ERROR'
                        }
                        GIT_COMMIT_TAG = sh 'cd test;git rev-parse --short HEAD'
                    }
                }
            }
        }

        stage('sonarqube-scanner') {
            agent { label 'jenkins-node1' }  // not mandatory to configure in stage
            steps {
                dir('/var/lib/jenkins/workspace/magedu-app1_deploy-20221120') {
                    // some block
                    sh '''
                        /apps/sonar-scanner/bin/sonar-scanner -Dsonar.projectKey=magedu -Dsonar.projectName=magedu-app1 -Dsonar.projectVersion=1.0  -Dsonar.sources=./sonar_python_scan -Dsonar.language=py -Dsonar.sourceEncoding=UTF-8
                    '''
                }
            }
        }

        stage('code build') {
            agent { label 'jenkins-node1' }
            steps {
                dir('/var/lib/jenkins/workspace/magedu-app1_deploy-20221120/web_test/app1-frontend-files-5.101') {
                    // some block
                    sh 'tar czvf frontend.tar.gz ./index.html ./images'
                }
            }
        }

        stage('file sync') {  //SSH Pipeline Steps
            agent { label 'jenkins-node1' }
            steps {
                dir('/var/lib/jenkins/workspace/magedu-app1_deploy-20221120/web_test') {
                    sh "ssh root@${env.NODE_3} 'mkdir -p /opt/ubuntu-dockerfile'"
                    sh "ssh root@${env.NODE_3} 'docker images'"
                    sh "ssh root@${env.NODE_3} 'docker ps'"
                    sh "scp ./app1-frontend-files-5.101/frontend.tar.gz root@${env.NODE_3}:/opt/ubuntu-dockerfile"
                    sh "scp ./ubuntu-dockerfile-6.201/build-command.sh root@${env.NODE_3}:/opt/ubuntu-dockerfile"
                }
            }
        }

        stage('image build') {  //SSH Pipeline Steps
            agent { label 'jenkins-node3' }
            steps {
                sh "mkdir -p '/var/lib/jenkins/workspace/magedu-app1_deploy-20221120'"
                dir('/var/lib/jenkins/workspace/magedu-app1_deploy-20221120') {
                    sh "cd /opt/ubuntu-dockerfile/ && bash ./build-command.sh ${GIT_COMMIT_TAG}-${DATE}"
                }
            }
        }

        stage('docker-compose image update') {
            steps {
                agent { label 'jenkins-node1' }
                sh """
                    ssh root@${env.NODE_3} "echo ${DATE} && rm -rf /data/magedu-app1;mkdir -p /data/magedu-app1;cd /data/magedu-app1 && sed -i  's#image: harbor.magedu.net/myserver/nginx:.*#image: harbor.magedu.net/myserver/nginx:${GIT_COMMIT_TAG}-${DATE}#' docker-compose.yml"
                """
            }
        }

        stage('docker-compose app update') {
            steps {
                agent { label 'jenkins-node1' }
                sh """
                   ssh root@${env.NODE_3} "echo ${DATE} && cd /data/magedu-app1 && docker-compose pull && docker-compose up -d"
                """
            }
        }

        stage('send email') {
            steps {
                sh 'echo send email'
            }
            post {
                always {
                    script {
                        mail to: '332348328@qq.com',
                        subject: "Pipeline Name: ${currentBuild.fullDisplayName}",
                        body: " ${env.JOB_NAME} -Build Number-${env.BUILD_NUMBER} \n Build URL-'${env.BUILD_URL}' "
                    }
                }
            }
        }
    }
}

