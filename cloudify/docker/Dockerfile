FROM cloudifyplatform/community-cloudify-manager-aio:6.2.0
ADD scripts /scripts
RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN yum install -y rsync wget fuse-sshfs sshpass unzip svn
