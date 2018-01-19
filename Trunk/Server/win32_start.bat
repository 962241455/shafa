@Rem Nginx Server Start bat
@::echo off
echo %0 %1
set oldDir=%cd%

cd /d %~dp0
cd Server_win32
set prefix=%cd%
start nginx -p %prefix% -c ../conf/nginx.conf
::tasklist /fi "imagename eq nginx.exe"

cd /d %oldDir%
if {%1} == {} pause
@::echo on
