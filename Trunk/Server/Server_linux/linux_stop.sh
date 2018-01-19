#!/bin/bash
oldDir=$(pwd)

cd `dirname $0`
./NginxServer/nginx/sbin/nginx -s stop

cd $oldDir
echo "stop server ok !"
