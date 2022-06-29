#!/bin/sh

# /opt/td-agent/embedded/bin/fluentd -c /etc/fluent/fluent.conf -d /var/run/td-agent/fluentd.pid -v

if [ "$FLUENTD" = "1" ]; then
  /opt/td-agent/bin/fluentd -c /etc/fluent/fluent.conf --no-supervisor -v &
  sleep 5
fi

IP=`hostname -I`
HOSTNAME=`hostname`

# ./jboss-cli.sh --connect --controller=master --user=admin --password=admin@2022 --command=':read-attribute(name=product-version)'

if [ -f "/mnt/share/domain.xml" ]; then
  cp /mnt/share/domain.xml /opt/jboss/domain/configuration/ 
fi 

if [ -f "/mnt/share/host-master.xml" ]; then
  cp /mnt/share/host-master.xml /opt/jboss/domain/configuration/ 
fi 

if [ -f "/mnt/share/host-slave.xml" ]; then
  cp /mnt/share/host-slave.xml /opt/jboss/domain/configuration/ 
fi 

if [ ! -d "/opt/jboss/domain/log" ]; then
  mkdir "/opt/jboss/domain/log"
fi

if [ $1 = "master" ]; then
	cd $JBOSS_HOME/bin && ./domain.sh --host-config=host-master.xml -Djboss.domain.base.dir=/opt/jboss/domain/ -Djboss.bind.address.management=$IP -Djboss.hostname=$HOSTNAME >> /opt/jboss/domain/log/console.log
elif [ $1 = "slave" ]; then
	cd $JBOSS_HOME/bin

	 while sleep 1; do ./jboss-cli.sh --connect --controller=master --user=admin --password=admin@2022 --command=':read-attribute(name=product-version)' >> /opt/jboss/domain/log/console.log
		 PROCESS_1_STATUS=$?
		 if [ $PROCESS_1_STATUS -eq 0  ]; then
			 break
		 fi
	done
	
	./domain.sh --host-config=host-slave.xml -Djboss.domain.base.dir=/opt/jboss/domain/ --backup --cached-dc -Djboss.domain.master.address=master -Djboss.domain.backup.address=backup -Djboss.bind.address.management=$IP -Djboss.bind.address=$IP -Djboss.hostname=$HOSTNAME >> /opt/jboss/domain/log/console.log
elif [ $1 = "bash" ]; then
	/bin/bash;
elif [ $1 = "cli" ]; then
	cd $JBOSS_HOME/bin && ./jboss-cli.sh;
elif [ $1 = "init" ]; then
	cd $JBOSS_HOME/bin && ./jboss-cli.sh --connect --controller=master --user=admin --password=admin@2022 --file=/opt/repositorio/init-dominio.txt;
	echo "Todo Bien?"
elif [ $1 = "test" ]; then
        echo "esto es un test en " $IP;
else
	/bin/bash;
fi

