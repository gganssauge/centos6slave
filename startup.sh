#!/bin/bash
HOST_IP=$(ip route | grep ^default | awk '{print $3}')
JENKINS_SERVER=${JENKINS_SERVER:-$HOST_IP}
JENKINS_PORT=${JENKINS_PORT:-8080}
JENKINS_LABELS=${JENKINS_LABELS:-swarm}
JENKINS_HOME=${JENKINS_HOME:-$HOME}
JENKINS_EXECUTORS=${JENKINS_EXECUTORS:-1}
export PATH=$HOME/py/bin:$PATH
echo "Starting up swarm client with args:"
echo "$@"
echo "and env:"
echo "$(env)"
set -x
java -jar $JENKINS_HOME/$SWARM_CLIENT \
    -fsroot "$JENKINS_HOME" \
    -labels "$JENKINS_LABELS" \
    -executors "$JENKINS_EXECUTORS" \
    -master http://$JENKINS_SERVER:$JENKINS_PORT \
    $@
sleep infinity
