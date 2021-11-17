#!/bin/bash
if [ $# -eq 0 ]
  then
    echo "usage: check_cloudify_availability <cloudify_server> <admin_password>"
    exit 1
fi
echo "Checking availability of Cloudify in " $1
counter=1
while [ $counter -le 10 ]
do
echo attempt: $counter
cfy profiles use $1 -t default_tenant -u admin -p $2 > /dev/null
if [ $? -eq 0 ]
then
  echo "Cloudify available"
  exit 0
fi
counter=$(( $counter + 1 ))
sleep 10
done
echo "Cloudify not available"
exit 1
