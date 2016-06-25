#!/bin/bash

source ./properties.sh .

echo "Starting new Docker image($registry/$maintainer/$imagename)"
docker run --name=$imagename -v /opt/blog:/opt/blog -d $maintainer/$imagename 

exit 0
