#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "usage: poststart.sh <new_admin_password>"
    exit
fi
echo "Executing poststart script..." >> /poststart.log
ip=`tail -1 /etc/hosts | awk '{ print $1}'`
new_password=$1
/bin/bash /scripts/check_cloudify_availability.sh $ip admin >> /poststart.log
/bin/bash /scripts/check_inner_nginx.sh >> /poststart.log
/bin/bash /scripts/configure_cloudify.sh $ip $new_password >> /poststart.log
# /bin/bash /scripts/check_cloudify_availability.sh $ip $new_password >> /poststart.log
echo "poststart script completed!" >> /poststart.log
