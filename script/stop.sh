#!/bin/sh
# ./stop.sh

docker stop -t 1 gitlab-ce
docker rm gitlab-ce
