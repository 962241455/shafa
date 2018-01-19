#!/bin/bash
oldDir=$(pwd)

cd `dirname $0`
dir=$(pwd)
prefix=$dir/php7
$prefix/sbin/php-fpm -c $prefix/php/php.ini -y $prefix/etc/php-fpm.conf -t
$prefix/sbin/php-fpm -c $prefix/php/php.ini -y $prefix/etc/php-fpm.conf

cd $oldDir
echo "php start ok !"
