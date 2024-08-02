pipeline {
    agent any

    environment { 
        ANSIBLE_PLAYBOOK_PATH = "../deploy.yml"
        ANSIBLE_INVENTORY = "../servers_inventory.ini"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }


        stage('Test') {
            steps {
                script {
                    sh 'JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 mvn clean test'
                }
            }
        }

        stage('Build') {
            steps {
                script {
                    sh 'JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 mvn clean package'
                }
            }
        }

        stage('Deploy') {
            when {
                branch 'master'
            }
            steps {
                script {
                    sh 'cp target/lavagna.war /tmp/lavagna.war'
                    
                    sh "ansible-playbook -i ${ANSIBLE_INVENTORY} ${ANSIBLE_PLAYBOOK_PATH}"
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
