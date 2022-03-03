#FROM centos
FROM quay.io/centos/centos:stream8
#FROM quay.io/centos/centos:8

RUN yum -y update && \
yum -y install hostname telnet unzip tar gzip net-tools mc openssh-server openssh-clients vim && \
yum clean all

RUN echo 'root:jboss' | chpasswd ; useradd -m jboss ; echo jboss: | chpasswd ; usermod -a -G wheel jboss

RUN mkdir -p /opt/instaladores && chown jboss:jboss /opt && chown jboss:jboss /opt/instaladores

USER jboss

WORKDIR /opt/instaladores

# En caso de tener los archivos jboss-eap-7.2.0.zip y jdk-8u66-linux-x64.tar.gz en el mismo directorio, descomentar la siguiente linea y comentar el siguiente RUN
# COPY --chown=jboss:jboss jboss-eap-7.2.0.zip jdk-8u66-linux-x64.tar.gz /opt/instaladores/
RUN curl -skL --remote-name https://www.planetaguru.com.ar/downloads/jboss-eap-7.2.0.zip && curl -skL --remote-name https://www.planetaguru.com.ar/downloads/jdk-8u66-linux-x64.tar.gz

WORKDIR /opt

RUN unzip instaladores/jboss-eap-7.2.0.zip && tar -xvzf instaladores/jdk-8u66-linux-x64.tar.gz && \ 
ln -s jboss-eap-7.2 jboss && \
ln -s jdk1.8.0_66 jdk

ENV JBOSS_HOME /opt/jboss
ENV EAP_HOME /opt/jboss
ENV JAVA_HOME /opt/jdk
ENV PATH $PATH:/opt/jdk/bin

# create JBoss console user
RUN $JBOSS_HOME/bin/add-user.sh admin admin@2020 --silent

### DESCOMENTAR para un jboss modo dominio funcionando
# COPY --chown=jboss:jboss domain.xml host-master.xml host-slave.xml /opt/jboss/domain/configuration/

# start JBoss
# ENTRYPOINT $JBOSS_HOME/bin/standalone.sh -c standalone-full-ha.xml
# ENTRYPOINT cd $JBOSS_HOME/bin && ./domain.sh --host-config=host-master.xml -Djboss.domain.base.dir=/opt/jboss/domain/
# CMD cd $JBOSS_HOME/bin && ./domain.sh --host-config=host-slave.xml -Djboss.domain.base.dir=/opt/jboss/domain/ --backup

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

