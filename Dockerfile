FROM ubuntu:14.04
 
RUN apt-get update && apt-get install -y wget git curl
RUN wget -q -O - http://pkg.jenkins-ci.org/debian-stable/jenkins-ci.org.key | sudo apt-key add -
RUN echo deb http://pkg.jenkins-ci.org/debian-stable binary/ >> /etc/apt/sources.list
#ADD init.groovy /tmp/WEB-INF/init.groovy
#RUN apt-get install -y zip && cd /tmp && zip -g /usr/share/jenkins/jenkins.war WEB-INF/init.groovy
RUN apt-get update && apt-get install -y rsync nodejs vim
USER jenkins
COPY healthcheck.js /

# VOLUME /var/jenkins_home - bind this in via -v if you want to make this persistent.
ENV JENKINS_HOME /var/jenkins_home

# for main web interface:
EXPOSE 8080 

# will be used by attached slave agents:
EXPOSE 50000 
CMD ["/usr/bin/java",  "-jar",  "/usr/share/jenkins/jenkins.war"]

HEALTHCHECK --interval=10s --timeout=10s --start-period=30s \  
 CMD nodejs /healthcheck.js

