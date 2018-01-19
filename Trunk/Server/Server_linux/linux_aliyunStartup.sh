#!/bin/bash
# 开机启动，可以在vi/etc/rc.local添加此脚本的执行
oldDir=$(pwd)

cd `dirname $0`
# sudo mount -t nfs -o vers=4.0 091a84b6a9-rvh7.cn-hangzhou.nas.aliyuncs.com:/ /local/mnt
mount -t nfs -o vers=3,nolock,proto=tcp 091a84b6a9-rvh7.cn-hangzhou.nas.aliyuncs.com:/ /mnt/sofa
sh php_start.sh
sh linux_start.sh

cd $oldDir
