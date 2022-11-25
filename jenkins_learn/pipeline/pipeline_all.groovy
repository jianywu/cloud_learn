#!groovy
pipeline {
    agent any  // global must configure agent.
    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
        disableConcurrentBuilds()
    }
    environment {
        def NODE_BUILD = "114.115.154.84"
        def NODE_GITLAB = "114.115.144.163"
        def NODE_HARBOR = "114.115.221.236"
        def APP1_DEPLOY_DIR = '/var/lib/jenkins/workspace/magedu-app1_deploy-20221120'
        def TEST_GIT_URL = "git@${env.NODE_GITLAB}:user3/test.git"
        def WEB_GIT_URL = "git@${env.NODE_GITLAB}:user3/web_test.git"
        def SONAR_GIT_URL = "git@${env.NODE_GITLAB}:user3/sonar_python_scan.git"
        def HARBOR_URL = 'harbor.magedu.net'
        def IMAGE_PROJECT = 'myserver'
        def IMAGE_NAME = 'nginx'
        def DATE = sh(script:'date +%F_%H-%M-%S', returnStdout: true).trim()
        // def GIT_COMMIT_TAG = ""
    }

    parameters {
        string(name: 'BRANCH', defaultValue:  'main', description: 'branch select') // string param
        choice(name: 'DEPLOY_ENV', choices: ['develop', 'production'], description: 'deploy env')  // option param
    }

    stages {
        stage('code clone') {
            agent { label 'jenkins-node1' }  // not mandatory to configure in stage
            steps {
                echo "Clean up env:"
                sh "rm -rf '/var/lib/jenkins/workspace/magedu-app1_deploy-20221120'"
                sh "mkdir -p '/var/lib/jenkins/workspace/magedu-app1_deploy-20221120'"
                dir('/var/lib/jenkins/workspace/magedu-app1_deploy-20221120') {
                    script {
                        echo "start clone code:"
                        if (env.BRANCH == 'main') {
                            git branch: 'main', credentialsId: '23e49037-3cb3-4dc6-9af9-fbe6a92eec11', url: "${env.WEB_GIT_URL}"
                            // sh "git clone -b main ${env.WEB_GIT_URL}"
                        } else if (env.BRANCH == 'develop') {
                            git branch: 'develop', credentialsId: '23e49037-3cb3-4dc6-9af9-fbe6a92eec11', url: "${env.WEB_GIT_URL}"
                            echo 'BRANCH PARAMETER ERROR'
                        }
                        // Note: GIT_COMMIT_TAG = sh 'git rev-parse --short HEAD' is null.
                        GIT_COMMIT_TAG = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
                        // Note: ${env.GIT_COMMIT_TAG} is null.
                        echo "GIT_COMMIT_TAG is ${GIT_COMMIT_TAG}"
                    }
                    // sh "git clone -b main ${env.TEST_GIT_URL}"
                    // sh "git clone -b main ${env.SONAR_GIT_URL}"
                }
            }
        }

        stage('sonarqube-scanner') {
            agent { label 'jenkins-node1' }  // not mandatory to configure in stage
            steps {
                dir('/var/lib/jenkins/workspace/magedu-app1_deploy-20221120') {
                    sh "git clone -b main ${env.SONAR_GIT_URL}"
                    echo "start sonar qube scan:"
                    sh '''
                        /apps/sonar-scanner/bin/sonar-scanner -Dsonar.projectKey=magedu -Dsonar.projectName=magedu-app1 -Dsonar.projectVersion=1.0  -Dsonar.sources=./sonar_python_scan -Dsonar.language=py -Dsonar.sourceEncoding=UTF-8
                    '''
                }
            }
        }

        stage('code build') {
            agent { label 'jenkins-node1' }
            steps {
                dir('/var/lib/jenkins/workspace/magedu-app1_deploy-20221120/app1-frontend-files-5.101') {
                    // some block
                    sh 'tar czvf frontend.tar.gz ./index.html ./images'
                }
            }
        }

        stage('file sync') {  //SSH Pipeline Steps
            agent { label 'jenkins-node1' }
            steps {
                dir('/var/lib/jenkins/workspace/magedu-app1_deploy-20221120') {
                    sh "ssh root@${env.NODE_HARBOR} 'mkdir -p /opt/ubuntu-dockerfile'"
                    sh "ssh root@${env.NODE_HARBOR} 'docker images'"
                    sh "ssh root@${env.NODE_HARBOR} 'docker ps'"
                    sh "scp ./app1-frontend-files-5.101/frontend.tar.gz root@${env.NODE_HARBOR}:/opt/ubuntu-dockerfile"
                    sh "scp -r ./ubuntu-dockerfile-6.201/* root@${env.NODE_HARBOR}:/opt/ubuntu-dockerfile"
                }
            }
        }

        stage('image build') {  //SSH Pipeline Steps
            agent { label 'jenkins-node4' }
            steps {
                // sh "ip a"
                sh "docker login harbor.magedu.net"
                // sh "mkdir -p '/var/lib/jenkins/workspace/magedu-app1_deploy-20221120'"
                // dir('/var/lib/jenkins/workspace/magedu-app1_deploy-20221120') {
                echo "GIT_COMMIT_TAG in build is ${GIT_COMMIT_TAG}"
                sh "cd /opt/ubuntu-dockerfile/ && bash ./build-command.sh ${GIT_COMMIT_TAG}-${DATE}"
                // }
            }
        }

        stage('docker-compose image update') {
            steps {
                // agent { label 'jenkins-node4' }
                sh """
                    ssh root@${env.NODE_BUILD} "echo ${DATE} && rm -rf /data/magedu-app1;mkdir -p /data/magedu-app1;cd /data/magedu-app1 && cp /var/lib/jenkins/workspace/magedu-app1_deploy-20221120/magedu-app1-composefile-6.202/docker-compose.yml /data/magedu-app1 && sed -i  's#image: harbor.magedu.net/myserver/nginx:.*#image: harbor.magedu.net/myserver/nginx:${GIT_COMMIT_TAG}-${DATE}#' docker-compose.yml"
                """
            }
        }

        stage('docker-compose app update') {
            steps {
                // agent { label 'jenkins-node4' }
                sh """
                   ssh root@${env.NODE_BUILD} "echo ${DATE} && cd /data/magedu-app1 && docker-compose pull && docker-compose up -d"
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
