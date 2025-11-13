@echo off
setlocal enabledelayedexpansion

if "%~1"=="" (
    echo Usage: %~nx0 input_file.cpp
    exit /b 1
)

where gcc >nul 2>nul
if %errorlevel% neq 0 (
    echo Error: GCC not found. Please install MinGW or other GCC distribution.
    exit /b 1
)

if not exist "%~1" (
    echo File not found: %~1
    exit /b 1
)

set "input_file=%~f1"
set "output_file=%~dpn1_no_comments%~x1"
set "temp_file=%temp%\%~n1_temp%~x1"

gcc -fpreprocessed -dD -E "%input_file%" > "%temp_file%" 2>nul
if %errorlevel% neq 0 (
    echo Error during processing
    del "%temp_file%" 2>nul
    exit /b 1
)

findstr /v /c:"#line" "%temp_file%" > "%output_file%"
del "%temp_file%" 2>nul

if exist "%output_file%" (
    echo Success: %output_file%
) else (
    echo Error: Failed to create output file
)