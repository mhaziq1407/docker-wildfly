
FROM java:8u77-jre-alpine

MAINTAINER Adriaan de Jonge <adejonge@xebia.com>

RUN apk --update add openssh curl \
  && sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config \
  && echo "root:root" | chpasswd \
  && rm -rf /var/cache/apk/*
COPY rootfs /


RUN cd /lib \
  && curl https://download.jboss.org/wildfly/21.0.0.Final/wildfly-21.0.0.Final.tar.gz | tar zx \
  && mv /lib/wildfly-21.0.0.Final /opt/wildfly

# create user
RUN /opt/jboss/wildfly/bin/add-user.sh admin Dfs1234@ --silent
# enable management console



ENV MSSQL_JDBC_VERSION 7.4.1.jre8

RUN rm /opt/jboss/wildfly/standalone/configuration/standalone.xml

RUN rm /opt/jboss/wildfly/bin/standalone.conf

ADD standalone.xml /opt/jboss/wildfly/standalone/configuration/

ADD standalone.conf /opt/jboss/wildfly/bin/


RUN mkdir -p /opt/jboss/wildfly/modules/system/layers/base/com/microsoft/sqlserver/jdbc/main && \
  cd /opt/jboss/wildfly/modules/system/layers/base/com/microsoft/sqlserver/jdbc/main && \
curl -L https://repo1.maven.org/maven2/com/microsoft/sqlserver/mssql-jdbc/$MSSQL_JDBC_VERSION/mssql-jdbc-$MSSQL_JDBC_VERSION.jar > mssql-jdbc.jar

ADD module.xml /opt/jboss/wildfly/modules/system/layers/base/com/microsoft/sqlserver/jdbc/main/



CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]

EXPOSE 22
EXPOSE 8081

CMD ["/sshd"]

