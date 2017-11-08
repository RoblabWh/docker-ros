#!/bin/bash

# Add local user
# Either use the LOCAL_USER_ID if passed in at runtime or
# fallback

USER_ID=${LOCAL_USER_ID:-9001}

echo "Starting with UID : $USER_ID"
chown -R $USER_ID:$USER_ID /home/container

useradd --shell /bin/bash -p $(openssl passwd -crypt docker) -u $USER_ID -U -G sudo -o -c "" container
echo "sudo ALL=(ALL:ALL) ALL" >> /etc/sudoers

set -e

# init setup, only if is new workspace
if [ ! -e /home/container/.bashrc ]
then
	source "/opt/ros/indigo/setup.bash"
	cd ~
	mkdir -p /home/container/ws/src && cd /home/container/ws/src && catkin_init_workspace && cd /home/container/ws/ && catkin build

	# setup ros environment
 	echo 'source /opt/ros/indigo/setup.bash' >> /home/container/.bashrc
  	echo 'source /home/container/ws/devel/setup.bash' >> /home/container/.bashrc
fi

exec /usr/local/bin/gosu container "$@"
