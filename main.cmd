:: superNT sourcing utility

@echo off
cd /d %~dp0

color 17

:: UAC Elevation
:: src: https://stackoverflow.com/a/12264592

:init
 setlocal DisableDelayedExpansion
 set cmdInvoke=1
 set winSysFolder=System32
 set "batchPath=%~0"
 for %%k in (%0) do set batchName=%%~nk
 set "vbsGetPrivileges=%temp%\OEgetPriv_%batchName%.vbs"
 setlocal EnableDelayedExpansion

:checkPrivileges
  NET FILE 1>NUL 2>NUL
  if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )

:getPrivileges
  if '%1'=='ELEV' (echo ELEV & shift /1 & goto gotPrivileges)
  ECHO.
  ECHO.
  ECHO Invoking UAC for Privilege Escalation 
  ECHO.

  ECHO Set UAC = CreateObject^("Shell.Application"^) > "%vbsGetPrivileges%"
  ECHO args = "ELEV " >> "%vbsGetPrivileges%"
  ECHO For Each strArg in WScript.Arguments >> "%vbsGetPrivileges%"
  ECHO args = args ^& strArg ^& " "  >> "%vbsGetPrivileges%"
  ECHO Next >> "%vbsGetPrivileges%"

  if '%cmdInvoke%'=='1' goto InvokeCmd 

  ECHO UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%vbsGetPrivileges%"
  goto ExecElevation

:InvokeCmd
  ECHO args = "/c """ + "!batchPath!" + """ " + args >> "%vbsGetPrivileges%"
  ECHO UAC.ShellExecute "%SystemRoot%\%winSysFolder%\cmd.exe", args, "", "runas", 1 >> "%vbsGetPrivileges%"

:ExecElevation
 "%SystemRoot%\%winSysFolder%\WScript.exe" "%vbsGetPrivileges%" %*
 exit /B

:gotPrivileges
 setlocal & cd /d %~dp0
 if '%1'=='ELEV' (del "%vbsGetPrivileges%" 1>nul 2>nul  &  shift /1)

:app-init
set active_drive=%~dp0

:: menus
:app-start

echo ================================================================================
echo                                     superNT
echo                                Sourcing Utility
echo ================================================================================
echo.
echo    [_] LICENSE AGREEMENT
echo.
echo     This software, provided by [workclocks] ("Licensor"), is licensed to the User without any warranties, whether expressed or implied. Licensor disclaims all warranties, including, but not limited to, implied warranties of merchantability and fitness for a particular purpose. The User assumes full responsibility for the selection and use of this software. Licensor shall not be held liable for any direct, indirect, incidental, special, or consequential damages arising from the use or inability to use the software. By using the software, the User acknowledges that they do so at their own risk.
echo.
echo     In accordance with this Agreement, the User is to understand and agree that the [source code] ("Sources") is not expressly owned or created by themself. The end user also may be subjective to copyright law, which the creator [workclocks] ("Licensor") is not responsible for any legal action taken against the end-user.
echo.

set /p "accept=Do you accept the license agreement (Y/N): "
if /i "%accept%"=="N" (
    exit
) else (
    goto app-home
)

:app-home
cls

echo ================================================================================
echo                                 Sourcing Utility
echo                                    Main Menu
echo ================================================================================
echo.
echo    [1] Select and Download Base Sources
echo    [2] Select and Download Modified Source Additions
echo    [3] Select Disk
echo.
echo    [0] Exit

:: Calculate line stuff
for /f %%A in ('"prompt $H & for %%B in (1) do rem"') do set "BS=%%A"
set /a "lines=(22 - 9) / 2"
for /l %%A in (1,1,%lines%) do echo.

:: Move cursor to bottom of screen
for /l %%A in (1,1,%lines%) do echo.
echo ================================================================================
set /p "menu_choice=Please type an option on the keyboard: "

if "%menu_choice%"=="1" goto app-download-bases
if "%menu_choice%"=="2" goto app-download-mod
if "%menu_choice%"=="3" goto app-drive-select
if "%menu_choice%"=="0" exit 

:app-drive-select
cls
echo ================================================================================
echo                                 Sourcing Utility
echo                                  Disk Selection
echo ================================================================================
echo.
echo    You must select a drive/disk to download the sources to.
echo    Current Drive: [%active_drive%]
echo.
echo    [1] Change Drive
echo    [2] Delete Existing Sources
echo.
echo    [0] Back
echo.

:: calculate line stuff
for /f %%A in ('"prompt $H & for %%B in (1) do rem"') do set "BS=%%A"
set /a "lines=(22 - 9) / 2"
for /l %%A in (1,1,%lines%) do echo.

:: move cursor to bottom of screen
for /l %%A in (1,1,%lines%) do echo.
echo ================================================================================
set /p "download_choice=Please type an option on the keyboard: "

if "%download_choice%"=="1" goto select-drive
if "%download_choice%"=="2" goto app-delete-source 
if "%download_choice%"=="0" goto app-home

