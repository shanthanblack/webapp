FROM tomcat:8
COPY web/target/*.war /usr/local/tomcat/webapps/webapp.war
