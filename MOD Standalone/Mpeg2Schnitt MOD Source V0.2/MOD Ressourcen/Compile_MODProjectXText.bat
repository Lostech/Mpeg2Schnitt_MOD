@echo off
echo Kompiliere MODProjectXText Ressource...
echo.
brcc32.exe MODProjectXText.txt
copy "MODProjectXText.res" "../MODProjectXText.res"
echo.
echo ...beendet!
pause