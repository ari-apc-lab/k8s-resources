#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "usage: change_password.sh <new_admin_password>"
    exit
fi
echo "Changing Cloudify password ..." 
ip=`tail -1 /etc/hosts | awk '{ print $1}'`
new_password=$1
/scripts/configure_cloudify.sh $ip $new_password>> /poststart.log
echo "change_password.sh completed!"
