FROM rastasheep/ubuntu-sshd:14.04

ENV WILDFLY_VERSION 9.0.0.Final

RUN apt-get update && apt-get install -y curl openjdk-7-jre-headless --no-install-recommends
RUN cd /opt && curl http://download.jboss.org/wildfly/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.tar.gz | tar zx && mv /opt/wildfly-$WILDFLY_VERSION /opt/wildfly

ENV JBOSS_HOME /opt/wildfly

EXPOSE 8081

CMD /usr/sbin/sshd && /opt/wildfly/bin/standalone.sh -b 0.0.0.0 -Djboss.http.port=8081
