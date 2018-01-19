@Rem Nginx Server Stop bat
@::echo off
echo %0 %1
set oldDir=%cd%

cd /d %~dp0
cd Server_win32
set prefix=%cd%
nginx -s stop
taskkill /fi "imagename eq nginx.exe" /f

cd /d %oldDir%
if {%1} == {} pause
@::echo on
