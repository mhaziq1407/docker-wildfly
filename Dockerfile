
FROM java:8u77-jre-alpine

MAINTAINER Adriaan de Jonge <adejonge@xebia.com>

RUN apk --update add openssh curl \
  && sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config \
  && echo "root:root" | chpasswd \
  && rm -rf /var/cache/apk/*
COPY rootfs /

RUN cd /lib \
  && curl https://download.jboss.org/wildfly/21.0.0.Final/wildfly-21.0.0.Final.tar.gz | tar zx \
  && mv /lib/wildfly-$WILDFLY_VERSION /lib/wildfly
ENV JBOSS_HOME /lib/wildfly

EXPOSE 22
EXPOSE 8081

CMD ["/sshd"]

