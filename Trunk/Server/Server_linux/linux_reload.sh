#!/bin/bash
oldDir=$(pwd)

cd `dirname $0`
prefix=$(pwd)
./NginxServer/nginx/sbin/nginx -t -p $prefix -c ../conf/nginx.conf
./NginxServer/nginx/sbin/nginx -s reload

cd $oldDir
