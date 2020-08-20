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
          jiraSendBuildInfo site: 'shanthanidentity.atlassian.net', environmentId: 'destro', environmentName: 'destro', environmentType: 'testing'
    }
  }
  
}
    stage ('Deploy-To-Tomcat') {
            steps {
                sh 'cp target/*.war /opt/tomcat/webapps/webapp.war'       
           }
          post {
                 always {
                     jiraSendDeploymentInfo site: 'shanthanidentity.atlassian.net', environmentId: 'destro', environmentName: 'destro', environmentType: 'testing'
                 }
             }
    }
    
    
    stage ('DAST') {
      steps {
         sh 'docker run -t owasp/zap2docker-stable zap-baseline.py -t http://10.0.2.15:8090/webapp/ || true'
      }
    }
    
  }
}
