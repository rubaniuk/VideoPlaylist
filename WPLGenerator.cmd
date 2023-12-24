:: WPLGenerator - Playlist generator for Microsoft Windows Media Player.
::
:: Reference:
:: https://ss64.com/nt/for_cmd.html
:: https://ss64.com/nt/delayedexpansion.html
:: https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/call#batch-parameters
::
@echo off
setlocal EnableDelayedExpansion

set exit_code_success=0
set exit_code_error_input_params=1

if "%~2"=="" (
    echo Incorrect input parameters
    call :foo_params
    exit /b %exit_code_error_input_params%
)

if "%~3" neq "" (
    echo Too many input parameters
    call :foo_params
    exit /b %exit_code_error_input_params%
)

if not exist "%~1" (
    echo Folder "%~1" doesn't exist. Enter valid folder path.
    call :foo_params
    exit /b %exit_code_error_input_params%
) 

set workingDir="%~1"
set outputFile="%~2"
set referencePath=%~1


:: don't forget to POPD when script exits!
pushd %workingDir%

if exist "%~2" (
    echo File "%~2" alredy exists. Enter different file name.
    call :foo_params

    :: popd from %workingDir%
    popd
    exit /b %exit_code_error_input_params%
) 

:: Generate new WPL playlist file XML:
echo ^<?xml version="1.0"?^> > %outputFile%
echo ^<smil^> >> %outputFile%
echo    ^<head^> >> %outputFile%
echo        ^<meta name="Generator" content="WPL Generator v1.0"/^> >> %outputFile%
:: TODO: add ItemCount, i.e. <meta name="ItemCount" content="106"/>
echo        ^<title^>%outputFile%^</title^> >> %outputFile%
echo    ^</head^> >> %outputFile%
echo    ^<body^> >> %outputFile%
echo        ^<seq^> >> %outputFile%

for /f "tokens=*" %%G in ('dir /b /s *.mp4') do (
    set pathToConvert=%%G
    set relativePath=!pathToConvert:*%referencePath%=!
    echo        ^<media src="!relativePath!"/^> >> %outputFile% 
)

echo        ^</seq^> >> %outputFile%
echo    ^</body^> >> %outputFile%
echo ^</smil^> >> %outputFile%

endlocal

:: popd from %workingDir%
popd
exit /b %exit_code_success%


:foo_params
echo Usage:
echo WPLGenerator.cmd ^<Path to the folder with videos^>  ^<Playlist file name^>
exit /b
