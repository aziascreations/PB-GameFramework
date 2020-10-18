@echo off
chcp 65001 >nul
echo ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
echo ┃ Automated build script v1.0 ┃
echo ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
set CPLR86="C:\Program Files\PureBasic\PureBasic_5.70_x86_x64\Compilers\pbcompiler.exe"
set CPLR64="C:\Program Files\PureBasic\PureBasic_5.70_x64\Compilers\pbcompiler.exe"
echo.

echo ━┫ Internal settings ┣━
:: XInput Module (Windows Only)
set MODULE_FRAMEWORK_XINPUT=1

:: DInput Module (Windows Only) (Not implemented !!!)
set MODULE_FRAMEWORK_DINPUT=0

:: Preparing the constants
set PB_COMPILER_MODULES=
if defined MODULE_FRAMEWORK_XINPUT (
	if "%MODULE_FRAMEWORK_XINPUT%" == "1" (
		echo Using XInput module !
		set PB_COMPILER_MODULES=%PB_COMPILER_MODULES% /CONSTANT FRAMEWORK_MODULE_XINPUT=#True
	)
)
echo Constants: %PB_COMPILER_MODULES%
echo.

echo ━┫ Preliminary clean-up ┣━
echo ● Deleting Build/
rmdir /Q /S Build\
echo ● Deleting Packages/
rmdir /Q /S Packages\
echo ● Deleting executables
del .\*.exe
echo.

echo ━┫ Environment setup ┣━
mkdir Build\
mkdir Build\Commons\
mkdir Build\Commons\Data\
mkdir Build\Commons\Licenses\
mkdir Build\x86\
mkdir Build\x86\Data\
mkdir Build\x86\Licenses\
mkdir Build\x64\
mkdir Build\x64\Data\
mkdir Build\x64\Licenses\
echo.

echo ━┫ Copying assets ┣━
copy .\LICENSE ".\Build\Commons\Licenses\Custom PB Framework.txt"
robocopy .\Libraries\x64\ .\Build\x64
robocopy .\Libraries\x86\ .\Build\x86
xcopy Data Build\Commons\Data\ /E /Y
xcopy Licenses Build\Commons\Licenses\ /E /Y
rmdir /Q /S Build\Commons\Data\Trash
rmdir /Q /S Build\Commons\Data\Graphics\Trash
rmdir /Q /S Build\Commons\Data\Launcher
del /s /q .\Build\Commons\*.pdn
del /s /q .\Build\Commons\*.tga
xcopy Build\Commons\Data\ Build\x64\Data\ /E /Y
xcopy Build\Commons\Licenses\ Build\x64\Licenses\ /E /Y
xcopy Build\Commons\Data\ Build\x86\Data\ /E /Y
xcopy Build\Commons\Licenses\ Build\x86\Licenses\ /E /Y
echo.

echo ━┫ Compiling x86 ┣━
%CPLR86% /EXE ".\Build\x86\Game.exe" /ICON ".\icon.ico" %PB_COMPILER_MODULES% ".\Game.pb"
%CPLR86% /EXE ".\Build\x86\Launcher.exe" /ICON ".\icon.ico" ".\Launcher.pb"
echo.

echo ━┫ Compiling x64 ┣━
%CPLR64% /EXE ".\Build\x64\Game.exe" /ICON ".\icon.ico" %PB_COMPILER_MODULES% ".\Game.pb"
%CPLR64% /EXE ".\Build\x64\Launcher.exe" /ICON ".\icon.ico" ".\Launcher.pb"
echo.

echo ━┫ Final clean-up ┣━
echo ● Deleting Build/Commons/
rmdir /Q /S Build\Commons\
echo.

pause
