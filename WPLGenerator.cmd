:: WPLGenerator - Playlist generator for Microsoft Windows Media Player.
::
:: Reference:
:: https://ss64.com/nt/for_d.html
:: https://ss64.com/nt/delayedexpansion.html
::
@echo off
setlocal EnableDelayedExpansion

echo ^<?xml version="1.0"?^> > Playlist.wpl
echo ^<smil^> >> Playlist.wpl
echo    ^<head^> >> Playlist.wpl
echo        ^<meta name="Generator" content="WPL Generator v1.0"/^> >> Playlist.wpl
echo        ^<title^>Playlist.wpl^</title^> >> Playlist.wpl
echo    ^</head^> >> Playlist.wpl
echo    ^<body^> >> Playlist.wpl
echo        ^<seq^> >> Playlist.wpl

for /f "tokens=*" %%G in ('dir /b /s *.mp4 *.mov') do (
    echo        ^<media src="%%G"/^> >> Playlist.wpl 
)

echo        ^</seq^> >> Playlist.wpl
echo    ^</body^> >> Playlist.wpl
echo ^</smil^> >> Playlist.wpl

endlocal
exit /b
