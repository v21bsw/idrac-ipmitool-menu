@echo off
TITLE Dell Server Fan Control Menu
COLOR 0A

:: ================= CONFIGURATION =================
:: Edit these values to match your friend's servers

::set SERVER1=192.168.50.233
::set SERVER3=192.168.50.232
::set SERVER2=192.168.50.231
::set SERVER4=192.168.50.230


set SERVER1=192.168.50.230
set SERVER2=192.168.50.231
set SERVER3=192.168.50.232
set SERVER4=192.168.50.233




:: Credentials for each server (case-sensitive)
set USERNAME1=admin
set PASSWORD1=admin

set USERNAME2=admin
set PASSWORD2=admin

set USERNAME3=admin
set PASSWORD3=admin

set USERNAME4=admin
set PASSWORD4=admin
:: =================================================

:menu
cls
echo ====================================
echo          DELL SERVER FAN CONTROL
echo ====================================
echo [1] Set Custom Fan Speed (10%% to 100%%)
echo [2] Set All Fans to 10%%
echo [3] Set All Fans to 100%%
echo [4] Put Fans to Auto Mode
echo [5] Check Fan Speed
echo [6] Check Ambient Temperature
echo [7] Turn OFF Fans
echo [8] Turn ON All Servers
echo [9] Turn OFF All Servers (CONFIRMATION REQUIRED)
echo [0] Exit
echo ====================================
set /p choice=Select an option (0-9): 

if "%choice%"=="1" goto custom_speed
if "%choice%"=="2" goto set_10
if "%choice%"=="3" goto set_100
if "%choice%"=="4" goto fans_auto
if "%choice%"=="5" goto check_fans
if "%choice%"=="6" goto check_temps
if "%choice%"=="7" goto turn_off_fans
if "%choice%"=="8" goto turn_on
if "%choice%"=="9" goto turn_off
if "%choice%"=="0" exit

echo Invalid option. Please enter a valid choice.
pause
goto menu


:rev_servers
set fan_percent=100
set fan_hex=0x64
goto apply_speed



:check_temps
cd "C:\Program Files (x86)\Dell\SysMgt\bmc"
echo Checking ambient temperature...
for %%S in (1 2 3 4) do (
    setlocal enabledelayedexpansion
    set "SERVER_IP=!SERVER%%S!"
    set "USER=!USERNAME%%S!"
    set "PASS=!PASSWORD%%S!"
    echo.
    echo === Server %%S: !SERVER_IP! ===
    ipmitool -I lanplus -H !SERVER_IP! -U !USER! -P !PASS! sdr type temperature
    endlocal
)
echo.
echo Temperature check completed.
pause
goto menu





:custom_speed
set /p fan_percent=Enter fan speed percentage (10-100): 
set /a fan_check=%fan_percent%+0 2>nul || goto invalid_input
if %fan_percent% LSS 10 goto invalid_input
if %fan_percent% GTR 100 goto invalid_input
for /f "delims=" %%a in ('powershell -NoProfile -Command "[Convert]::ToString(%fan_percent%,16).ToUpper()"') do set fan_hex=%%a
set fan_hex=0x%fan_hex%
goto apply_speed

:invalid_input
echo ERROR: Invalid input. Please enter a number between 10 and 100.
pause
goto menu

:set_10
set fan_percent=10
set fan_hex=0x0A
goto apply_speed

:set_100
set fan_percent=100
set fan_hex=0x64
goto apply_speed

:apply_speed
cd "C:\Program Files (x86)\Dell\SysMgt\bmc"
for %%S in (1 2 3 4) do (
    setlocal enabledelayedexpansion
    set "SERVER_IP=!SERVER%%S!"
    set "USER=!USERNAME%%S!"
    set "PASS=!PASSWORD%%S!"
    ipmitool -I lanplus -H !SERVER_IP! -U !USER! -P !PASS! raw 0x30 0x30 0x01 0x00 >nul 2>&1
    ipmitool -I lanplus -H !SERVER_IP! -U !USER! -P !PASS! raw 0x30 0x30 0x02 0xff !fan_hex! >nul 2>&1
    endlocal
)
echo Fan speed set to %fan_percent%%% (%fan_hex% in hex).
pause
goto menu

:fans_auto
cd "C:\Program Files (x86)\Dell\SysMgt\bmc"
for %%S in (1 2 3 4) do (
    setlocal enabledelayedexpansion
    set "SERVER_IP=!SERVER%%S!"
    set "USER=!USERNAME%%S!"
    set "PASS=!PASSWORD%%S!"
    ipmitool -I lanplus -H !SERVER_IP! -U !USER! -P !PASS! raw 0x30 0x30 0x01 0x01 >nul 2>&1
    endlocal
)
echo Fans set to automatic control.
pause
goto menu

:check_fans
cd "C:\Program Files (x86)\Dell\SysMgt\bmc"
echo Checking fan speeds...
for %%S in (1 2 3 4) do (
    setlocal enabledelayedexpansion
    set "SERVER_IP=!SERVER%%S!"
    set "USER=!USERNAME%%S!"
    set "PASS=!PASSWORD%%S!"
    echo.
    echo === Server %%S: !SERVER_IP! ===
    ipmitool -I lanplus -H !SERVER_IP! -U !USER! -P !PASS! sdr type fan
    endlocal
)
pause
goto menu


:turn_off_fans
cd "C:\Program Files (x86)\Dell\SysMgt\bmc"
set fan_percent=0
set fan_hex=0x00
for %%S in (1 2 3 4) do (
    setlocal enabledelayedexpansion
    set "SERVER_IP=!SERVER%%S!"
    set "USER=!USERNAME%%S!"
    set "PASS=!PASSWORD%%S!"
    ipmitool -I lanplus -H !SERVER_IP! -U !USER! -P !PASS! raw 0x30 0x30 0x01 0x00 >nul 2>&1
    ipmitool -I lanplus -H !SERVER_IP! -U !USER! -P !PASS! raw 0x30 0x30 0x02 0xff !fan_hex! >nul 2>&1
    endlocal
)
echo Fans are now OFF (0%%).
pause
goto menu


:turn_on
cd "C:\Program Files (x86)\Dell\SysMgt\bmc"
echo Powering ON servers...
for %%S in (1 2 3 4) do (
    setlocal enabledelayedexpansion
    set "SERVER_IP=!SERVER%%S!"
    set "USER=!USERNAME%%S!"
    set "PASS=!PASSWORD%%S!"
    ipmitool -I lanplus -H !SERVER_IP! -U !USER! -P !PASS! power on >nul 2>&1
    endlocal
)
pause
goto menu

:turn_off
cd "C:\Program Files (x86)\Dell\SysMgt\bmc"
echo Are you sure you want to SHUT DOWN all servers? (Y/N)
set /p confirm=
if /I "%confirm%"=="Y" (
    for %%S in (1 2 3 4) do (
        setlocal enabledelayedexpansion
        set "SERVER_IP=!SERVER%%S!"
        set "USER=!USERNAME%%S!"
        set "PASS=!PASSWORD%%S!"
        ipmitool -I lanplus -H !SERVER_IP! -U !USER! -P !PASS! power off >nul 2>&1
        endlocal
    )
    echo.
    echo Servers are shutting down.
    timeout /t 3 /nobreak >nul
) else (
    echo Shutdown CANCELED.
)
pause
goto menu
