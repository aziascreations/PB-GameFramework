@echo off
echo Reading config...

:: ########## THIS IS WHERE YOU MODIFY THE BUILD OPTIONS ##########

:: ##### Paths #####

:: - Full path to the x86 version of the PB compiler.
set CPLR86="C:\Program Files\PureBasic\PureBasic_5.70_x86_x64\Compilers\pbcompiler.exe"

:: - Full path to the x64 version of the PB compiler.
set CPLR64="C:\Program Files\PureBasic\PureBasic_5.70_x64\Compilers\pbcompiler.exe"

:: - Full path to the 7z executable.
set ZIPEXE="C:\Program Files\7-Zip\7z.exe"


:: ##### Project options #####

:: - Project file name
set PROJECT_FILENAME=Project.pbp

:: - Project x64 compiler name
set PROJECT_X64_COMPILER_NAME=PureBasic 5.70 LTS (Windows - x64)

:: - Project x86 compiler name
set PROJECT_X86_COMPILER_NAME=PureBasic 5.70 LTS (Windows - x86)

:: - Toggle for the x64 target
set PROJECT_X64_TOGGLE=1

:: - Toggle for the x86 target
set PROJECT_X86_TOGGLE=1

:: - Toggle for making the x64 target the default one
set PROJECT_X64_DEFAULT=1

:: - Toggle for making the x86 target the default one
set PROJECT_X86_DEFAULT=0


:: ##### Build options #####

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

:: - Greedy copy mode for PB licenses (Not used yet)
:: |-> 0 - Only copies the PB licenses required by the framework
:: |-> 1 - Copies every PB licenses regardless of wether they are used or not
set LICENSES_GREEDY_PB_COPY=1


:: ##### Module toggles #####

:: - Toggle for the XInput module
set FRAMEWORK_MODULE_XINPUT=1

:: - Toggle for the Google Snappy module (Will include a new license in the build process)
set FRAMEWORK_MODULE_SNAPPY=0

:: - Toggle for the Arguments module
set FRAMEWORK_MODULE_ARGUMENTS=0


:: ##### Packaging options #####

:: - Project name used in the package's names.
set PACKAGE_APP_NAME=PB-Framework


:: ########## DO NOT MODIFY ANYTHING AFTHER THIS POINT !!! ##########

:end
::echo End of config script !
exit /b
