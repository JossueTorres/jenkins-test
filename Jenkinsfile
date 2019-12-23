pipeline {
    agent { docker { image 'ubuntu:18.04' } }
    stages {
        stage('Build') {
            steps {
                sh 'echo "Hello World"'
                sh '''
                    echo "Multiline shell steps works too"
                    ls -lah
                '''
            }
        }
        stage('Version'){
            steps{
                sh 'java -version'
            }
        }
        stage('From-Script'){
            steps{
                sh 'script.sh'
            }
        }
    }
}
