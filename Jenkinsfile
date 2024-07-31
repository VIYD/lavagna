pipeline {
    agent any

    environment {
        TOMCAT_HOST = '192.168.56.57' 
        TOMCAT_USER = 'tomcatadmin' 
        TOMCAT_PASSWORD = '1111'
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
                    curl -u ${TOMCAT_USER}:${TOMCAT_PASSWORD} \
                    -T target/${WAR_FILE_NAME} \
                    http://${TOMCAT_HOST}:8080/manager/text/deploy?path=/ROOT&update=true
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
