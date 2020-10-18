@echo off
chcp 65001 >nul
echo ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
echo ┃ Automated build script v2.0 ┃
echo ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
echo.
goto build-settings


:build-settings
echo ━┫ Internal settings ┣━
call build-config
set PB_COMPILER_OPTIONS=
if defined EXECUTABLE_ICON_ENABLE (
	if defined EXECUTABLE_ICON_PATH (
		if "%EXECUTABLE_ICON_ENABLE%" == "1" (
			echo Using custom executable icon !
			set PB_COMPILER_OPTIONS=%PB_COMPILER_OPTIONS% /ICON %EXECUTABLE_ICON_PATH%
		)
	)
)
set PB_COMPILER_MODULES=
if defined MODULE_FRAMEWORK_XINPUT (
	if "%MODULE_FRAMEWORK_XINPUT%" == "1" (
		echo Using XInput module !
		set PB_COMPILER_MODULES=%PB_COMPILER_MODULES% /CONSTANT FRAMEWORK_MODULE_XINPUT=#True
	)
)
echo Done !
echo.
goto build-clean


:build-clean
echo ━┫ Preliminary clean-up ┣━
call build-clean
echo Done !
echo.
goto build-setup


:build-setup
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
echo Done !
echo.
goto build-copy


:build-copy
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
echo Done !
echo.
goto build-x86


:build-x86
if defined EXECUTABLE_X86_ENABLE (
	if "%EXECUTABLE_X86_ENABLE%" == "1" (
		echo ━┫ Compiling x86 ┣━
		%CPLR86% /EXE ".\Build\x86\%EXECUTABLE_GAME_NAME%"%PB_COMPILER_OPTIONS%%PB_COMPILER_MODULES% ".\Game.pb"
		if errorlevel 1 (
			set ERROR_CUSTOM_MESSAGE=Failed to compile the x86 build of the game !
			goto error
		)
		if defined EXECUTABLE_LAUNCHER_ENABLE (
			if "%EXECUTABLE_LAUNCHER_ENABLE%" == "1" (
				%CPLR86% /EXE ".\Build\x86\%EXECUTABLE_LAUNCHER_NAME%"%PB_COMPILER_OPTIONS% ".\Launcher.pb"
				if errorlevel 1 (
					set ERROR_CUSTOM_MESSAGE=Failed to compile the x86 build of the launcher !
					goto error
				)
			)
		)
		echo Done !
		echo.
	)
)
goto build-x64


:build-x64
if defined EXECUTABLE_X64_ENABLE (
	if "%EXECUTABLE_X64_ENABLE%" == "1" (
		echo ━┫ Compiling x64 ┣━
		%CPLR64% /EXE ".\Build\x64\%EXECUTABLE_GAME_NAME%"%PB_COMPILER_OPTIONS%%PB_COMPILER_MODULES% ".\Game.pb"
		if errorlevel 1 (
			set ERROR_CUSTOM_MESSAGE=Failed to compile the x64 build of the game !
			goto error
		)
		if defined EXECUTABLE_LAUNCHER_ENABLE (
			if "%EXECUTABLE_LAUNCHER_ENABLE%" == "1" (
				%CPLR64% /EXE ".\Build\x64\%EXECUTABLE_LAUNCHER_NAME%"%PB_COMPILER_OPTIONS% ".\Launcher.pb"
				if errorlevel 1 (
					set ERROR_CUSTOM_MESSAGE=Failed to compile the x64 build of the launcher !
					goto error
				)
			)
		)
		echo Done !
		echo.
	)
)
goto build-finish


:build-finish
echo ━┫ Final clean-up ┣━
echo ● Deleting Build/Commons/
rmdir /Q /S Build\Commons\
echo Done !
echo.
goto end


:error
:: Ring the terminal bell
:: Source: https://rosettacode.org/wiki/Terminal_control/Ringing_the_terminal_bell#Batch_File
for /f %%. in ('forfiles /m "%~nx0" /c "cmd /c echo 0x07"') do set bell=%%.
echo %bell%
echo ############################################################
echo A fatal error occured while building the application !
echo ^> %ERROR_CUSTOM_MESSAGE%
echo ############################################################
echo.
goto end


:end
pause
