#!/bin/bash
oldDir=$(pwd)

yum install readline-devel pcre-devel openssl-devel gcc gcc-c++
cd `dirname $0`
dir=$(pwd)
prefix=$dir/NginxServer
cd ./openresty-1.11.2.2
chmod 755 ./pcre-8.34/configure
chmod 755 ./configure
make clean
./configure --prefix=$prefix --with-ipv6 --with-pcre=./pcre-8.34 --with-pcre-jit
gmake
chmod 755 ./build/install
gmake install

cd $oldDir
echo "install ok !"
