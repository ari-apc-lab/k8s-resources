#!/bin/bash

# Rationale:
#
# The configure_cloudify.sh script returns the following error
#   "ProcessExecutionError: Failed running command: ['sudo', 'supervisorctl', '-c', '/etc/supervisord.conf', 'update', 'nginx']"
# after running the this command
#   "cfy_manager configure --private-ip $ip --public-ip $ip --clean-db -a $password"
# if it is executed too soon (after Cloudify's deployment).
# So, this script adds a step to check if the inner instance of nginx is
# up and running before resetting Cloudify's password.

echo "Checking availability of inner nginx"
counter=1
while [ $counter -le 20 ]
do
  echo attempt: $counter
  if ps aux | pgrep nginx
  then
    echo "Inner nginx available"
    sleep 15
    exit 0
  fi
  counter=$(( $counter + 1 ))
  sleep 10
done
echo "Inner nginx not available: password change might fail"
exit 1