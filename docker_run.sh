#!/bin/bash

docker build -t octoblu/octo-master:latest .
fleetctl destroy octo-master@.service
fleetctl submit ./.systemd/octo-master@.service
./rolling-restart.sh octo-master
