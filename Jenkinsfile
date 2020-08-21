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
          jiraEditComment comment: 'comment overhead modified in jenkins pipeline', commentId: '10007', idOrKey: 'PT-3', site: 'jira'
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
         sh 'docker run -t owasp/zap2docker-stable zap-baseline.py -t http://10.0.2.15:8090/webapp/ || true'
      }
    }
    
  }
}
