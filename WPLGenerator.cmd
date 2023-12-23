:: WPLGenerator - Playlist generator for Microsoft Windows Media Player.
::
:: Reference:
:: https://ss64.com/nt/for_d.html
:: https://ss64.com/nt/delayedexpansion.html
::
@echo off
setlocal EnableDelayedExpansion

if "%~1"=="" (
    echo No input parameters.
    call :foo_params
    exit /b
)

if "%~2" neq "" (
    echo Too many input parameters
    call :foo_params
    exit /b
)

if exist "%~1" (
    echo File "%~1" alredy exists. Enter different file name.
    call :foo_params
    exit /b    
) 

set outputFile="%~1"


:: TODO: temporarily PUSHD into that directory

echo ^<?xml version="1.0"?^> > %outputFile%
echo ^<smil^> >> %outputFile%
echo    ^<head^> >> %outputFile%
echo        ^<meta name="Generator" content="WPL Generator v1.0"/^> >> %outputFile%
echo        ^<title^>%outputFile%^</title^> >> %outputFile%
echo    ^</head^> >> %outputFile%
echo    ^<body^> >> %outputFile%
echo        ^<seq^> >> %outputFile%

for /f "tokens=*" %%G in ('dir /b /s *.mp4 *.mov') do (
    :: TODO make %%G into a relative path so that when this folder is copied, playlist can be used
    echo        ^<media src="%%G"/^> >> %outputFile% 
)

echo        ^</seq^> >> %outputFile%
echo    ^</body^> >> %outputFile%
echo ^</smil^> >> %outputFile%

:: TODO: POPD from new working directory

endlocal
exit /b 0


:foo_params
echo Usage:
echo WPLGenerator.cmd ^<playlist name^>
exit /b
