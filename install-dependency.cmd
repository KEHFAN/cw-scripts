@echo off
:: check window os name
for /f "tokens=2 delims==" %%i in ('wmic os get Caption /value^|find "Caption"') do set var1=%%i
echo current os name: %var1%
for /f "tokens=1-3" %%a in ("%var1%") do set "os=%%a %%b %%c"
echo current os name: %os%

if "%os%"=="Microsoft Windows 10" (
    echo ok
    :: goto 到win10
) else if "%os%"=="Microsoft Windows 7" (
    echo OK 7
) else (
    :: 其他系统
    echo fail other os
)
