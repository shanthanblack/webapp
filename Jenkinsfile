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


stage ('Build') {
      steps {
      sh 'mvn clean package'
    }
    }
    stage ('Gauntlt-script-execution') {
      steps {
        sh 'gauntlt test.attack'
      }
    }
    
    
    stage ('Deploy-To-Tomcat') {
            steps {
                sh 'cp target/*.war /opt/tomcat/webapps/webapp.war'       
           }       
    }
    
    
    stage ('DAST') {
      steps {
         sh 'docker run -t owasp/zap2docker-stable zap-baseline.py -t http://10.0.2.15:8090/webapp/ || true'
      }
    }
    
  }
}
