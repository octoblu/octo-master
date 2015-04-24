#!/bin/bash

MESHBLU_HOST=10.0.2.2
MESHBLU_PORT=3000

NEW_DEVICE_JSON=$(curl -s -XPOST http://$MESHBLU_HOST:$MESHBLU_PORT/devices)
OCTO_MASTER_UUID=`docker run --rm --name jq realguess/jq \
  sh -c "echo '${NEW_DEVICE_JSON}' | jq -r '.uuid'"`
OCTO_MASTER_TOKEN=`docker run --rm --name jq realguess/jq \
  sh -c "echo '${NEW_DEVICE_JSON}' | jq -r '.token'"`

etcdctl set meshblu/host $MESHBLU_HOST
etcdctl set meshblu/port $MESHBLU_PORT
etcdctl set octo-master/uuid $OCTO_MASTER_UUID
etcdctl set octo-master/token $OCTO_MASTER_TOKEN

exit 0
