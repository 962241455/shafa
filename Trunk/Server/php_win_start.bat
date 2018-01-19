@Rem Nginx Server Start bat
@::echo off
echo %0 %1
set oldDir=%cd%

cd /d %~dp0
start /b D:\php7\php-cgi.exe -b 127.0.0.1:9000 -c D:\php7\php.ini
cd /d %oldDir%

if {%1} == {} pause
@::echo on
