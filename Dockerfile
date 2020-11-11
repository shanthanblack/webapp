FROM tomcat:8
COPY target/WebApp.war /usr/local/tomcat/webapps/webapp.war
