@echo off

:: clean, compile, build
set PATH=%PATH%;C:\Program Files\PureBasic\PureBasic_5.70_x64\Compilers\

rmdir /Q /S Build\
rmdir /Q /S Packages\
del .\*.exe

mkdir Build\
mkdir Build\Data\
mkdir Build\Licenses\

pbcompiler /EXE ".\Build\Game.exe" /ICON ".\icon.ico" ".\Game.pb"
robocopy .\ .\Build\ Engine3d.dll
robocopy .\ .\Build\ LICENSE
xcopy Data Build\Data\ /E /Y
xcopy Licenses Build\Licenses\ /E /Y

pause
