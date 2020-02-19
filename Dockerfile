FROM tomcat:alpine
MAINTAINER DevOps Team
RUN wget -O /usr/local/tomcat/webapps/launchstation04.war http://10.127.130.66:8040/artifactory/webapp/#/artifacts/browse/tree/General/agrimmarkan.3148133/com/nagp2019/agrim/3148133/demosampleapplication/1.0.0-SNAPSHOT/demosampleapplication-1.0.0-SNAPSHOT.war
EXPOSE 8000
CMD /usr/local/tomcat/bin/catalina.sh run
