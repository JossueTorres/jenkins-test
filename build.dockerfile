# Starting off with the Jenkins base Image
FROM jenkins/jenkins

# RUN keytool -genkey -keyalg "RSA" -alias "selfsigned" -keystore jenkins_keystore.jks -storepass "mypassword" -keysize 2048

# VOLUME /var/jenkins_home 

ARG JDK_PATH

ENV JAVA_HOME=$JDK_PATH

ENV CUSTOM_TrustStore = $JENKINS_HOME/.cacerts/
RUN mkdir var/jenkins_home/.cacerts/
RUN ls -a
RUN ls -a var/jenkins_home/
RUN cp $JAVA_HOME/jre/lib/security/cacerts $CUSTOM_TrustStore

VOLUME /var/jenkins_home     