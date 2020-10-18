@echo off
echo Reading config...

:: ########## THIS IS WHERE YOU MODIFY THE BUILD OPTIONS ##########

:: ##### Paths

:: - Full path to the x86 version of the PB compiler.
set CPLR86="C:\Program Files\PureBasic\PureBasic_5.70_x86_x64\Compilers\pbcompiler.exe"

:: - Full path to the x64 version of the PB compiler.
set CPLR64="C:\Program Files\PureBasic\PureBasic_5.70_x64\Compilers\pbcompiler.exe"

:: - Full path to the 7z executable.
set ZIPEXE="C:\Program Files\7-Zip\7z.exe"


:: ##### Build options

:: - Common executable icon toggle
:: |-> 0 - Don't compile the apps with an icon
:: |-> 1 - Compile the apps with the icon in the %EXECUTABLE_ICON_PATH% variable.
set EXECUTABLE_ICON_ENABLE=0

:: - Path to the desired application icon (ignore if %EXECUTABLE_ICON_ENABLE% is set to 0)
set EXECUTABLE_ICON_PATH=".\icon.ico"

:: - Game's executable name
set EXECUTABLE_GAME_NAME=Game.exe

:: - Launcher's compilation toggle
:: |-> 0 - Don't compile the launcher
:: |-> 1 - Compile the launcher with %EXECUTABLE_LAUNCHER_NAME% as the executable name.
set EXECUTABLE_LAUNCHER_ENABLE=0

:: - Launcher's executable name (ignore if %EXECUTABLE_LAUNCHER_ENABLE% is set to 0)
set EXECUTABLE_LAUNCHER_NAME=Launcher.exe

:: - X64 compilation toggle
:: |-> 0 - Don't compile the x64 version of the game and launcher
:: |-> 1 - Compile the x64 version of the game and launcher
set EXECUTABLE_X64_ENABLE=1

:: - X86 compilation toggle
:: |-> 0 - Don't compile the x86 version of the game and launcher
:: |-> 1 - Compile the x86 version of the game and launcher
set EXECUTABLE_X86_ENABLE=1

:: - Common executable icon toggle
:: |-> 0 - Don't include the XInput module
:: |-> 1 - Include the XInput module in the game
set MODULE_FRAMEWORK_XINPUT=1



:: ##### Packaging options

:: - Project name used in the package's names.
set PACKAGE_APP_NAME=PB-Framework


:: ########## DO NOT MODIFY ANYTHING AFTHER THIS POINT !!! ##########

:end
::echo End of config script !
exit /b
