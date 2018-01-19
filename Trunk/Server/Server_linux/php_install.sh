#!/bin/bash
oldDir=$(pwd)

yum -y install libxml2 libxml2-devel openssl openssl-devel bzip2 bzip2-devel libcurl libcurl-devel libjpeg libjpeg-devel libmcrypt libmcrypt-devel readline readline-devel re2c curl curl-devel
yum -y install  libpng libpng-devel freetype freetype-devel gmp gmp-devel libxslt libxslt-devel
cd `dirname $0`
dir=$(pwd)
prefix=$dir/php7
cd ./php-7.1.6
make clean
#./configure --prefix=$prefix  --enable-fpm --with-libdir=lib64 --with-pear --with-openssl --with-curl --with-gettext --with-mysqli --with-pdo-mysql --with-pdo-sqlite --with-pcre-regex --with-iconv-dir --with-xmlrpc --with-libxml-dir --with-zlib --with-kerberos --with-freetype-dir --with-gd --with-png-dir --with-xsl --enable-fpm --enable-bcmath --enable-libxml --enable-inline-optimization --enable-mbregex --enable-mbstring --enable-pcntl --enable-shmop --enable-soap --enable-sockets --enable-sysvsem --enable-xml --enable-zip --enable-gd-native-ttf --enable-opcache
./configure --prefix=$prefix  --enable-fpm --with-libdir=lib64 --with-pear --with-openssl --with-curl --with-gettext --with-mysqli --with-pdo-mysql --with-pdo-sqlite --with-pcre-regex --with-iconv-dir --with-xmlrpc --with-libxml-dir --with-zlib                                                                         --enable-fpm --enable-bcmath --enable-libxml --enable-inline-optimization --enable-mbregex --enable-mbstring --enable-pcntl --enable-shmop --enable-soap --enable-sockets --enable-sysvsem --enable-xml --enable-zip
gmake
gmake install
cp php.ini-development $prefix/php/php.ini
cp $prefix/etc/php-fpm.conf.default $prefix/etc/php-fpm.conf
cp $prefix/etc/php-fpm.d/www.conf.default $prefix/etc/php-fpm.d/www.conf
# www.conf 文件中加入： user = nginx    group = nginx
# php-fpm.conf 文件中加入： pid = run/php-fpm.pid    error_log = log/php-fpm.log    log_level = notice
# php.ini 文件中加入： cgi.fix_pathinfo=1

cd $oldDir
echo "php install ok !"
