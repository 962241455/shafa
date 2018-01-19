@Rem Nginx Server Start bat
@::echo off
echo %0 %1
set oldDir=%cd%

cd /d %~dp0
taskkill /fi "imagename eq php-cgi.exe" /f
cd /d %oldDir%

if {%1} == {} pause
@::echo on
