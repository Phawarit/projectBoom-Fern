#!/bin/bash
NAME="regpms";
rm $(pwd)/tmp/pids/server.pid;
docker stop $NAME;
docker rm $NAME;
docker run  -v $(pwd):/usr/src/app \
  -p 3002:3000 \
  --name $NAME \
  -w /usr/src/app \
  -e MYAPP_RELATIVE_URL_ROOT='regpms' \
  -e RAILS_SERVE_STATIC_FILES=true \
  kritssa/regpms rails s;


docker run  -v ${PWD}:/usr/src/app   -p 3002:3000     -w /usr/src/app   -e MYAPP_RELATIVE_URL_ROOT='regpms'   -e RAILS_SERVE_STATIC_FILES=true kritssa/regpms rails server;