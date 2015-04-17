#!/bin/bash

docker build -t octoblu/octo-master:devel .

docker run -it \
  --rm \
  --name octo-master \
  -e DEBUG=octo-master* \
  -e MESHBLU_DEVICE_UUID=bb834050-e546-11e4-869f-8d68b2238a65 \
  -e MESHBLU_DEVICE_TOKEN=fc617e88b357545ef7f8982f0b373fd577c11132 \
  -e KUBERNETES_PROVIDER=aws \
  -e KUBERNETES_MASTER=https://52.11.220.249 \
  -v /Users/octoblu/tmp/kubernetes:/root/.kube \
  octoblu/octo-master:devel $@
