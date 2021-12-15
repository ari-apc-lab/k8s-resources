ip=$1
password=$2
echo New Cloudify IP: $ip
echo New Cloudify password: $password
echo 'Reconfiguring Cloudify'
cfy_manager configure --private-ip $ip --public-ip $ip --clean-db -a $password
