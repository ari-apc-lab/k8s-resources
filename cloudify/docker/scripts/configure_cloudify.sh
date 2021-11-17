echo 'Updating Cloudify internal IP'
#ip=`tail -1 /etc/hosts | awk '{ print $1}'`
ip=$1
default_cfy_ip='172.17.0.2'
echo New K8s IP: $ip
sed -i "s/$default_cfy_ip/$ip/g" /etc/cloudify/config.yaml
sed -i "s/$default_cfy_ip/$ip/g" /opt/mgmtworker/work/broker_config.json
sed -i "s/$default_cfy_ip/$ip/g" /etc/sysconfig/cloudify-mgmtworker
echo 'Reconfiguring Cloudify'
cfy_manager configure --clean-db -a $2
