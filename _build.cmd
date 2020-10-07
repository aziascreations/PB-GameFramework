@echo off

:: clean, compile, build
set PATH=%PATH%;C:\Program Files\PureBasic\PureBasic_5.70_x64\Compilers\

rmdir /Q /S Build\
rmdir /Q /S Packages\
del .\*.exe

:: x86
::mkdir Build\
::mkdir Build\x86
::mkdir Build\x86\Data\
::mkdir Build\x86\Licenses\
::"C:\Program Files\PureBasic\PureBasic_5.70_x86_x64\Compilers\pbcompiler.exe" /EXE ".\Build\x86\Game.exe" /ICON ".\icon.ico" ".\Game.pb"
::robocopy .\ .\Build\x86\ Engine3d.dll
::robocopy .\ .\Build\x86\ LICENSE
::xcopy Data Build\x86\Data\ /E /Y
::xcopy Licenses Build\x86\Licenses\ /E /Y

:: x64
::mkdir Build\x64
::mkdir Build\x64\Data\
::mkdir Build\x64\Licenses\
::"C:\Program Files\PureBasic\PureBasic_5.70_x64\Compilers\pbcompiler.exe" /EXE ".\Build\x64\Game.exe" /ICON ".\icon.ico" ".\Game.pb"
::robocopy .\ .\Build\x64\ Engine3d.dll
::robocopy .\ .\Build\x64\ LICENSE
::xcopy Data Build\x64\Data\ /E /Y
::xcopy Licenses Build\x64\Licenses\ /E /Y

:: Default
mkdir Build\
mkdir Build\Data\
mkdir Build\Licenses\
pbcompiler.exe /EXE ".\Build\Game.exe" /ICON ".\icon.ico" ".\Game.pb"
::pbcompiler.exe /EXE ".\Build\Game.exe" ".\Game.pb"
robocopy .\ .\Build\ Engine3d.dll
::robocopy .\ .\Build\ LICENSE
copy .\LICENSE ".\Build\Licenses\Custom PB Engine.txt"
xcopy Data Build\Data\ /E /Y
xcopy Licenses Build\Licenses\ /E /Y
rmdir /Q /S Build\Data\Trash
rmdir /Q /S Build\Data\Graphics\Trash
del /s /q .\Build\*.pdn
del /s /q .\Build\*.tga

pause
