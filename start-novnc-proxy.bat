@echo off

:: Get the directory of the batch script
set "SCRIPT_DIR=%~dp0"

:: Launch PowerShell script with execution policy bypassed in a separate window
start powershell.exe -ExecutionPolicy Bypass -File "%SCRIPT_DIR%start.ps1"

:: Close the current command prompt window
exit
