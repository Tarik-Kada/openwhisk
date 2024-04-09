#!/bin/bash

# Stop and remove KinD cluster
docker ps -a | grep "kindest/node" | awk '{print $1}' | xargs docker stop
docker ps -a | grep "kindest/node" | awk '{print $1}' | xargs docker rm