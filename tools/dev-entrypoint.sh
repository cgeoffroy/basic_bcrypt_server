#! /bin/sh -e
# set -x

CE_PATH=/home/code_executor
cat ${CE_PATH}/.ssh/keys/* 1> ${CE_PATH}/.ssh/authorized_keys
chmod 600 ${CE_PATH}/.ssh/authorized_keys
env | sed 's/^/export /' >> ${CE_PATH}/.profile
echo 'export FROM_DOT_PROFILE=1'  >> ${CE_PATH}/.profile

# IP=$(ip -4 addr show dev eth0 | grep inet | sed 's/^[ ]*//' | cut -d ' ' -f 2 | sed 's/[/].*//')
# sudo dropbear
# echo "Ssh server listening on ${IP}:22"

if [ $# -eq 0 ];
then
    /bin/bash
else
    $*
fi
