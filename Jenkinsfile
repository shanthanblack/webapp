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
         sh 'wget "https://raw.githubusercontent.com/adarshreddy94/webapp/master/owasp-dependency-check.sh" '
         sh 'chmod 777 owasp-dependency-check.sh'
         sh 'bash owasp-dependency-check.sh'
         sh 'cat /var/lib/jenkins/workspace/PT-3/odc-reports/dependency-check-report.xml'
        
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
  post {
    always {
          jiraSendBuildInfo branch: 'PT-3', site: 'shanthanidentity.atlassian.net'
    }
  }
  
}
    
    stage ('Deploy-To-Tomcat') {
            steps {
                sh 'cp target/*.war /opt/tomcat/webapps/webapp.war'       
           }
          post {
                 always {
                     jiraSendDeploymentInfo environmentId: 'test-1', environmentName: 'test-1', environmentType: 'testing', site: 'shanthanidentity.atlassian.net', state: 'in_progress'
                 }
             }
    }
    
    
    stage ('DAST') {
      steps {
         sh 'docker run -t owasp/zap2docker-stable zap-baseline.py -t http://52.66.251.253:8090/webapp/ || true'
      }
    }
    
  }
}
