#!/bin/bash

function trap_sigterm() {
	echo "Signal trap triggered, beginning shutdown.." 
	killall sshd
}

trap 'trap_sigterm' SIGINT SIGTERM

CONFIG=/sshd

echo "PGBACKREST env vars are set to:"
set | grep PGBACKREST

echo "CONFIG is.."
ls $CONFIG
echo "REPO is ..."
ls $REPO

mkdir ~/.ssh/
cp $CONFIG/config ~/.ssh/
cp $CONFIG/id_rsa /tmp
chmod 400 /tmp/id_rsa ~/.ssh/config

# start sshd which is used by pgbackrest for remote connections
/usr/sbin/sshd -D -f $CONFIG/sshd_config   &

/opt/cpm/bin/pgo-backrest-restore

echo "pgo-backrest-restore ending"