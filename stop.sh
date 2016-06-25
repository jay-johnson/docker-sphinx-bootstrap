#!/bin/bash

source ./properties.sh .

echo "Stopping Docker image($registry/$maintainer/$imagename)"
docker stop $imagename

exit 0
