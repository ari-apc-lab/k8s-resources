echo "Executing poststart script." 
ip=`tail -1 /etc/hosts | awk '{ print $1}'`
/scripts/configure_cloudify.sh $ip $1>> /poststart.log
/scripts/check_cloudify_availability.sh $ip $1>> /poststart.log
echo "poststart script completed!"
