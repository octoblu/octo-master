#!/bin/bash

docker build -t octoblu/octo-master:devel .

docker stop octo-master &> /dev/null
docker rm octo-master &> /dev/null
docker run -it \
  --name octo-master \
  --detach \
  -e DEBUG=octo-master* \
  -e MESHBLU_DEVICE_UUID=0b6968f0-a147-4f95-a4d0-8a99a0a937f9 \
  -e MESHBLU_DEVICE_TOKEN=0efe24cd5c8ee974dad8aeadffe15fa2d3c7223e \
  -v /var/run/fleet.sock:/var/run/fleet.sock \
  octoblu/octo-master:devel $@
