pipeline {
    agent any

    environment { 
        ANSIBLE_PLAYBOOK_PATH = "../deploy.yml"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build and Test') {
            steps {
                script {
                    sh 'JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 mvn clean package'
                }
            }
        }

        stage('Prepare Artifact') {
            steps {
                script {
                    def pom = readMavenPom file: 'pom.xml'  // Move this inside the script block
                    sh "mv target/lavagna.war target/lavagna-${pom.version}.war"
                }
            }
        }

        stage('Put [SNAPSHOT] artifact') {
            when {
                allOf {
                    branch "main"
                    tag "snapshot-*"
                }
            }
            steps {
                script {
                    def pom = readMavenPom file: 'pom.xml'
                    echo "Copying artifact to /mnt/snapshots/lavagna-${pom.version}.war"
                    sh "cp target/lavagna-${pom.version}.war /mnt/snapshots/lavagna-${pom.version}.war"
                }
            }
        }

        stage('Put [RELEASE] artifact') {
            when {
                allOf {
                    tag "release-*"
                    branch "main"
                }
            }
            steps {
                script {
                    def pom = readMavenPom file: 'pom.xml'
                    echo "Copying artifact to /mnt/releases/lavagna-${pom.version}.war"
                    sh "cp target/lavagna-${pom.version}.war /mnt/releases/lavagna-${pom.version}.war"
                }
            }
        }

        stage('Deploy [RELEASE] artifact') {
            when {
                allOf {
                    tag "release-*"
                    branch "main"
                }
            }
            steps {
                script {
                    def pom = readMavenPom file: 'pom.xml'
                    echo "Deploying version ${pom.version}"
                    sh "ansible-playbook ${ANSIBLE_PLAYBOOK_PATH} --extra-vars 'version=${pom.version}'"
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
