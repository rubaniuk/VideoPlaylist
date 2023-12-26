:: VideoPlaylist - Playlist generator for Microsoft Windows Media Player.
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
echo        ^<meta name="Generator" content="WPL Generator v1.2"/^> >> %outputFile%
:: TODO: add ItemCount, i.e. <meta name="ItemCount" content="106"/>
echo        ^<title^>%outputFile%^</title^> >> %outputFile%
echo    ^</head^> >> %outputFile%
echo    ^<body^> >> %outputFile%
echo        ^<seq^> >> %outputFile%

:: prepare variables for '&' replacement in final XML:
set "find=&"
set "replace=&amp;"

for /f "tokens=*" %%G in ('dir /b /s /on ^
*.webm, *.mkv, *.vob, *.ogv, *.ogg, *.drc, *.gifv, *.mng, *.avi, *.MTS, *.M2TS, *.TS, *.mov, *.qt, *.wmv, *.yuv, *.rm, *.rmvb, *.viv, *.asf, *.amv, ^
*.mp4, *.m4p, *.m4v, *.mpg, *.mp2, *.mpeg, *.mpe, *.mpv, *.m2v, *.svi, *.3gp, *.3g2, *.mxf, *.roq, *.nsv, *.flv, *.f4v, *.f4p, *.f4a, *.f4b') do (
    set pathToConvert=%%G
    set _relativePath=!pathToConvert:*%referencePath%=!

    :: replace all occurances of '&' with '&amp;'. Note that double quotes are critical here:
    call set "_relativePath=%%_relativePath:!find!=!replace!%%"

    REM TODO: if  _relativePath doesn't end in '\' we should add it. This bug prevents WMP from opening the playlist.

    :: write processed relative path into XML:
    echo        ^<media src="!_relativePath!"/^> >> %outputFile% 
)

echo        ^</seq^> >> %outputFile%
echo    ^</body^> >> %outputFile%
echo ^</smil^> >> %outputFile%

endlocal

:: popd from %workingDir%
popd

echo Video Playlist "%outputFile%" was successfully created in "workingDir".
echo Enjoy your playlist!
exit /b %exit_code_success%


:foo_params
echo Usage:
echo VideoPlaylist.cmd ^<Path to the folder with videos^>  ^<Playlist file name^>
exit /b
