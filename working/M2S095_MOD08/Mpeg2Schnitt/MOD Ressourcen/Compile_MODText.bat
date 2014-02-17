@echo off
echo Kompiliere MODText Ressource...
echo.
brcc32.exe MODText.txt
copy "MODText.res" "../MODText.res"
echo.
echo ...beendet!
pause