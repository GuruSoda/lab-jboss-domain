#!/bin/sh

service ssh start
service apache2 start

# choripaneado de https://docs.docker.com/config/containers/multi-service_container/

while sleep 10; do ps aux | grep ssh | grep -q -v grep
  PROCESS_1_STATUS=$?
  # If the greps above find anything, they exit with 0 status
  # If they are not both 0, then something is wrong
  if [ $PROCESS_1_STATUS -ne 0  ]; then
    echo "SSH no ejecutando."
    exit 1
  fi
done

# tail -f /var/log/apache2 
