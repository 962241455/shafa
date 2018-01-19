#!/bin/bash
oldDir=$(pwd)

cd `dirname $0`
prefix=$(pwd)
ln -fs NginxServer/nginx/logs logs
ln -fs NginxServer/nginx/html html
./NginxServer/nginx/sbin/nginx -p $prefix -c ../conf/nginx.conf

cd $oldDir
echo "start server ok !"
