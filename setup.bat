@echo off
SETLOCAL

:: Check for Python and install if necessary
python --version > NUL 2>&1
IF NOT %ERRORLEVEL% == 0 (
    ECHO Python is not installed. Please install Python and make sure it is added to PATH.
    EXIT /B 1
)

:: Install required Python packages
ECHO Checking and installing required Python packages...
python -m pip install numpy > NUL

:: Clone noVNC if not already present
SET "SCRIPT_DIR=%~dp0"
IF NOT EXIST "%SCRIPT_DIR%noVNC" (
    python -c "import os; os.system('git clone https://github.com/novnc/noVNC \\"%SCRIPT_DIR%noVNC\\"')"
)

:: Create a shortcut to start-novnc-proxy.bat in the Startup folder
ECHO Creating a shortcut to start noVNC proxy at startup
SET "SHORTCUT_PATH=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\Start noVNC Proxy.lnk"
SET "TARGET_PATH=%SCRIPT_DIR%start-novnc-proxy.bat"
ECHO Set oWS = WScript.CreateObject("WScript.Shell") > "%temp%\temp.vbs"
ECHO sLinkFile = "%SHORTCUT_PATH%" >> "%temp%\temp.vbs"
ECHO Set oLink = oWS.CreateShortcut(sLinkFile) >> "%temp%\temp.vbs"
ECHO oLink.TargetPath = "%TARGET_PATH%" >> "%temp%\temp.vbs"
ECHO oLink.Save >> "%temp%\temp.vbs"
cscript /nologo "%temp%\temp.vbs"
DEL "%temp%\temp.vbs"

ENDLOCAL
