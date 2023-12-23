:: WPLGenerator - Playlist generator for Microsoft Windows Media Player.
::
:: Reference:
:: https://ss64.com/nt/for_d.html
:: https://ss64.com/nt/delayedexpansion.html
::
@echo off
setlocal EnableDelayedExpansion
:: TODO: do robust input parameter validation

:: TODO: get path to Photo/Video from command line and assign it to outputFile

:: TODO: check if given path exists

:: TODO: temporarily PUSHD into that directory


set outputFile=Playlist.wpl

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
exit /b
