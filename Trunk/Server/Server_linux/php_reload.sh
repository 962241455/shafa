#!/bin/bash
oldDir=$(pwd)

cd `dirname $0`
dir=$(pwd)
prefix=$dir/php7
kill -USR2 `cat $prefix/var/run/php-fpm.pid`

cd $oldDir
echo "php reload ok !"
