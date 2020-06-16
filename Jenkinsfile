pipeline {
  agent any 
  tools {
    maven 'maven'
  }
  stages {
    stage ('Initialize') {
      steps {
        sh '''
                    echo "PATH = ${PATH}"
                    echo "M2_HOME = ${M2_HOME}"
            ''' 
      }
    }
    
    stage ('Check-Git-Secrets') {
      steps {
        sh 'rm trufflehog || true'
        sh 'docker run gesellix/trufflehog --json  https://github.com/shanthanblack/webapp.git > trufflehog'
        sh 'cat trufflehog'
      }
    }
    
   stage ('Source Composition Analysis') {
      steps {
         sh 'rm owasp* || true'
         sh 'wget "https://raw.githubusercontent.com/shanthanblack/webapp/master/owasp-dependency-check.sh" '
         sh 'chmod +x owasp-dependency-check.sh'
         sh 'bash owasp-dependency-check.sh'
         sh 'cat /var/lib/jenkins/OWASP-Dependency-Check/reports/dependency-check-report.xml'
        
      }
    }

    stage ('SAST') {
      steps {
        withSonarQubeEnv('sonar') {
          sh 'mvn sonar:sonar'
          sh 'cat target/sonar/report-task.txt'
        }
      }
    }
    
stage ('Build') {
      steps {
      sh 'mvn clean package'
    }
    }
    stage ('Open-port-scanning') {
      steps {
        sh 'sh port.sh'
      }
    }
    
    stage ('Deploy-To-Tomcat') {
            steps {
              sshagent(['ssh-con']) {
                sh 'scp -o StrictHostKeyChecking=no target/*.war ubuntu@13.232.91.215:/opt/tomcat/webapps/webapp.war'  
              }      
           }       
    }
    
    
    stage ('DAST') {
      steps {
         sh 'ssh -o  StrictHostKeyChecking=no ubuntu@13.232.91.215 "docker run -t owasp/zap2docker-stable zap-baseline.py -t http://13.232.120.152:8090/webapp/" || true'
      }
    }
    
  }
}
