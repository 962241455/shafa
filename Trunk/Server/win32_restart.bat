@Rem Nginx Server ReStart bat

set oldDir=%cd%

cd /d %~dp0
call ./win32_stop.bat restart
cd /d %~dp0
call ./win32_start.bat restart

cd /d %oldDir%
pause
