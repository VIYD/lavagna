pipeline {
    agent any

    environment {
        TOMCAT_HOST = '192.168.56.57' 
        TOMCAT_USER = 'vagrant'       
        TOMCAT_PATH = '/opt/tomcat/webapps' 
        WAR_FILE_NAME = 'lavagna.war'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                script {
                    sh 'mvn clean package'
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    sh """
                    scp -o StrictHostKeyChecking=no target/${WAR_FILE_NAME} ${TOMCAT_USER}@${TOMCAT_HOST}:${TOMCAT_PATH}/
                    """
                }
            }
        }
    }

    post {
        success {
            echo 'Build and deployment successful!'
        }
        failure {
            echo 'Build or deployment failed.'
        }
    }
}
