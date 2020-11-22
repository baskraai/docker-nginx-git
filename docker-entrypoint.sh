#!/bin/bash
set -e

source helpfunctions.sh

if [ "${SSH_KEY_MOUNT}" != "" ]; then
	echo_info "Option specified that ssh keys are mounted"
	cp -r "$SSH_KEY_MOUNT" ~/.ssh
	if [ ! $? ]; then
		echo_failed "Could not copy keys, does the SSH KEY mount work correctly?"
		exit 1
	fi
        chmod 700 ~/.ssh/id*
	echo_ok "GIT SSH Keys succesfully set"
elif [ "${SSH_PRIVKEY}" == "" ]; then
	echo_failed "SSH_PRIVKEY not specified."
	exit 1
elif [ "${SSH_PUBKEY}" == "" ] ; then
	echo_failed "SSH_PUBKEY not specified."
	exit 1
else
	echo_info "Settings the Git SSH Keys"
	mkdir -p ~/.ssh
	echo "$SSH_PUBKEY" > ~/.ssh/id_ecdsa.pub
	echo "$SSH_PRIVKEY" > ~/.ssh/id_ecdsa
	chmod 700 ~/.ssh/id_ecdsa*
	echo_ok "GIT SSH Keys succesfully set"
fi

if [ "${CONFIG_REPO}" == "" ]; then
	echo_failed "CONFIG_REPO not defined"
	exit 1
else
	echo_info "Cloning the config from git"
	cd ~
	GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no" git clone "$CONFIG_REPO" config
	echo_ok "Cloning config succesful"
fi

if [ "${SINGLE_CONFIG_NAME}" != "" ]; then
	echo_info "Only use the configfile ${SINGLE_CONFIG_NAME}"
	mv "config/nginx/${SINGLE_CONFIG_NAME}" /etc/nginx/nginx.conf
	if [ ! $? ]; then
		echo_failed "Could not the config"
		exit 1
	fi
	echo_ok "Copying config succesful"
else
	echo_info "Copying the nginx config"
	rsync -aq config/nginx/* /etc/nginx/
	echo_ok "Copying config succesful"
fi

echo_info "Checking the config"
 nginx -t
if [ ! $? ]; then
	echo_failed "NGINX config test failed."
	tail /var/log/nginx/*.log
	exit 1
fi

echo_info "Starting the nginx deamon"
nginx -g 'daemon off;'

if [ ! $? ]; then
	echo_failed "nginx deamon failed"
	tail /var/log/nginx/*.log
	exit 1
fi
