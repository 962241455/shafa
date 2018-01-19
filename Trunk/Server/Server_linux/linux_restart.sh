#!/bin/bash
oldDir=$(pwd)

cd `dirname $0`
sh linux_stop.sh
sleep 1
sh linux_start.sh

cd $oldDir
