#!/bin/bash

docker build -t octoblu/octo-master:devel .

docker run -it \
  --rm \
  --name octo-master \
  -e DEBUG=octo-master* \
  -e MESHBLU_DEVICE_UUID=fc6da000-dd81-11e4-b399-ab04e144916d \
  -e MESHBLU_DEVICE_TOKEN=f5e95ef1a9f03c049cae544ae3e47f3df08dfb8a \
  -e KUBERNETES_PROVIDER=aws \
  -e KUBERNETES_MASTER=https://52.11.220.249 \
  -v /Users/octoblu/tmp/kubernetes:/root/.kube \
  octoblu/octo-master:devel $@
