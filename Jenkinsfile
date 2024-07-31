pipeline {
    agent any

    environment {
        ANSIBLE_PLAYBOOK_PATH = "deploy.yml"
        ANSIBLE_INVENTORY = "servers_inventory.ini"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
                sh 'chmod +x build-with-java-8.sh'
            }
        }

        stage('Build') {
            steps {
                script {
                    sh './build-with-java-8.sh'
                }
            }
        }

        stage('Deploy') {
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
