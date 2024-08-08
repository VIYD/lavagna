pipeline {
    agent any

    environment { 
        ANSIBLE_PLAYBOOK_PATH = "../deploy.yml"
        ANSIBLE_INVENTORY = "../servers_inventory.ini"
        pom = readMavenPom file: 'pom.xml'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }


        // stage('Test') {
        //     steps {
        //         script {
        //             sh 'JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 mvn clean test'
        //         }
        //     }
        // }

        stage('Build and Test') {
            steps {
                script {
                    sh 'JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 mvn clean package'
                }
            }
        }

        stage('Put [SNAPSHOT] artifact') {
            when {
                allOf {
                    tag "snapshot-*"
                    branch "main"
                }
            }
            steps {
                script {
                    echo "Copying artifact to /mnt/snapshots/lavagna-${pom.version}.war"
                    sh 'cp target/lavagna.war /mnt/snapshots/lavagna-${pom.version}.war'
                }
            }
        }

        stage('Put [RELEASE] artifact') {
            when {
                allOf {
                    // tag "release-*"
                    branch "main"
                }
            }
            steps {
                script {
                    def version = pom.version
                    echo "Copying artifact to /mnt/releases/lavagna-${version}.war"
                    sh 'cp target/lavagna.war /mnt/releases/lavagna-${version}.war'
                }
            }
        }

        stage('Deploy if release') {
            when {
                allOf {
                    // tag "release-*"
                    branch "main"
                }
            }
            steps {
                script {
                    def version = pom.version
                    echo "Deploying version ${version}"

                    // sh 'cp target/lavagna.war /mnt/releases/lavagna-${version}.war'
                    
                    sh "ansible-playbook -i ${ANSIBLE_INVENTORY} ${ANSIBLE_PLAYBOOK_PATH} --extra-vars 'version=${version}'"
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
