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
                sh 'chmod +x set-java-8-env.sh'
                sh 'chmod +x set-java-11-env.sh'
            }
        }

        stage('Set Java 8') {
            steps {
                script {
                    sh './set-java-8-env.sh'
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    sh 'mvn clean test'
                }
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
                    sh 'cp target/lavagna.war /tmp/lavagna.war'
                    
                    sh "ansible-playbook -i ${ANSIBLE_INVENTORY} ${ANSIBLE_PLAYBOOK_PATH}"
                }
            }
        }

        stage('Set Java 11') {
            steps {
                script {
                    sh './set-java-11-env.sh'
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
