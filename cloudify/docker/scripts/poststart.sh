#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "usage: poststart.sh <new_admin_password>"
    exit
fi
echo "Executing poststart script..." 
ip=`tail -1 /etc/hosts | awk '{ print $1}'`
new_password=$1
/scripts/check_cloudify_availability.sh $ip admin>> /poststart.log
/scripts/configure_cloudify.sh $ip $new_password>> /poststart.log
/scripts/check_cloudify_availability.sh $ip $new_password>> /poststart.log
echo "poststart script completed!"
