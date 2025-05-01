pipeline {

    agent none

    options {
    
        disableConcurrentBuilds(abortPrevious: true)
        
        buildDiscarder(logRotator(numToKeepStr: '1'))
    }
     
    stages {
  
        stage('docker compose build') {
            
            agent {
            
                label "aventador"
            
            }

            steps {

                dir('.') {

                    sh 'docker compose build'
                    
                }                

            }

        }   

        stage('docker compose push') {

            agent {
            
                label "aventador"
            
            }

            steps {

                dir('.') {

                    sh 'docker compose push'
                    
                }                  

            }

        }    
  
        stage('prune') {

            agent {
            
                label "aventador"
            
            }

            steps {

                dir('.') {

                    sh 'docker system prune -a -f'
                    
                }                  

            }

        }  
        
}}

