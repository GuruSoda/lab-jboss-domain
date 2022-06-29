#FROM centos
FROM quay.io/centos/centos:stream8
#FROM quay.io/centos/centos:8

RUN yum -y update && \
yum -y install epel-release hostname telnet unzip tar gzip net-tools mc vim sudo && \
yum clean all

RUN dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm

RUN yum install -y htop

RUN curl -L https://toolbelt.treasuredata.com/sh/install-redhat-td-agent4.sh | sh

RUN echo 'root:jboss' | chpasswd ; useradd -m jboss ; echo jboss: | chpasswd ; usermod -a -G wheel jboss

RUN mkdir -p /opt/instaladores && chown jboss:jboss /opt && chown jboss:jboss /opt/instaladores

USER jboss

WORKDIR /opt/instaladores

# En caso de tener los archivos jboss-eap-7.3.0.zip y jdk-11.0.14_linux-x64_bin.tar.gz en el mismo directorio, descomentar la siguiente linea y comentar el siguiente RUN
# COPY --chown=jboss:jboss jboss-eap-7.3.0.zip jdk-11.0.14_linux-x64_bin.tar.gz /opt/instaladores/
RUN curl -skL --remote-name https://www.planetaguru.com.ar/downloads/jboss-eap-7.3.0.zip && curl -skL --remote-name https://www.planetaguru.com.ar/downloads/jdk-11.0.14_linux-x64_bin.tar.gz

WORKDIR /opt

RUN unzip instaladores/jboss-eap-7.3.0.zip && tar -xvzf instaladores/jdk-11.0.14_linux-x64_bin.tar.gz && \
ln -s jboss-eap-7.3 jboss && \
ln -s jdk-11.0.14 jdk

ENV JBOSS_HOME /opt/jboss
ENV EAP_HOME /opt/jboss
ENV JAVA_HOME /opt/jdk
ENV PATH $PATH:/opt/jdk/bin

# create JBoss console user
RUN $JBOSS_HOME/bin/add-user.sh admin admin@2022 --silent

### DESCOMENTAR para un jboss modo dominio funcionando
# COPY --chown=jboss:jboss domain.xml host-master.xml host-slave.xml /opt/jboss/domain/configuration/

# start JBoss
# ENTRYPOINT $JBOSS_HOME/bin/standalone.sh -c standalone-full-ha.xml
# ENTRYPOINT cd $JBOSS_HOME/bin && ./domain.sh --host-config=host-master.xml -Djboss.domain.base.dir=/opt/jboss/domain/
# CMD cd $JBOSS_HOME/bin && ./domain.sh --host-config=host-slave.xml -Djboss.domain.base.dir=/opt/jboss/domain/ --backup

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

