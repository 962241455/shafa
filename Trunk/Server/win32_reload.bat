@Rem Nginx Server ReStart bat

set oldDir=%cd%

cd /d %~dp0
cd Server_win32
set prefix=%cd%
nginx -t -p %prefix% -c ../conf/nginx.conf
nginx -s reload

cd /d %oldDir%
pause
