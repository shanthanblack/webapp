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

    
stage ('Build') {
      steps {
      sh 'mvn clean package'
    }
  post {
    always {
          jiraSendBuildInfo branch: 'master', site: 'shanthanidentity.atlassian.net'
    }
  } 
} 
    stage ('Deploy-To-Tomcat') {
            steps {
                sh 'cp target/*.war /opt/tomcat/webapps/webapp.war'       
           }
          post {
                 always {
                     jiraSendDeploymentInfo site: 'shanthanidentity.atlassian.net', environmentId: 'ap-prod-1', environmentName: 'ap-prod-1', environmentType: 'production'
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
