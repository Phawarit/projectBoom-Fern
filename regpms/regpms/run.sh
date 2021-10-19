#!/bin/bash
NAME="regpms";
rm $(pwd)/tmp/pids/server.pid;
docker stop $NAME;
docker rm $NAME;
docker run   -v $(pwd):/usr/src/app \
  --restart=always \
  -p 3000:3000 \
  --name $NAME \
  -w /usr/src/app \
  kritssa/regpms   rails s ;
#  ;
#  -v /data/ftp/pmsfile:/home/app/webapp/public/files \
