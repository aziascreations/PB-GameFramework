@echo off
chcp 65001 >nul
echo ┏━━━━━━━━━━━━━━━━━━━━━━┓
echo ┃ Project Builder v1.0 ┃
echo ┗━━━━━━━━━━━━━━━━━━━━━━┛
echo.
goto project-settings


:project-settings
echo ━┫ Internal settings ┣━
call build-config
echo Done !
echo.
goto project-clean


:project-clean
echo ━┫ Cleaning ┣━
call build-clean
del /S *.pbp
echo Done !
echo.
goto project-make


:project-make
echo ━┫ Creating file ┣━
echo ^<?xml version="1.0" encoding="UTF-8"?^> >> %PROJECT_FILENAME%
echo. >> %PROJECT_FILENAME%
echo ^<project xmlns="http://www.purebasic.com/namespace" version="1.0" creator="Project Builder v1.0"^> >> %PROJECT_FILENAME%
echo ^<section name="config"^> >> %PROJECT_FILENAME%
echo ^<options closefiles="1" openmode="0" name="PureBasic 2D/3D Game Framework Test"/^> >> %PROJECT_FILENAME%
echo ^<comment^>THE GAME SHOULD SHOULD NOT BE BUILT FOR RELEASE VIA THIS PROJECT !!!^</comment^> >> %PROJECT_FILENAME%
echo ^</section^> >> %PROJECT_FILENAME%
echo ^<section name="data"^> >> %PROJECT_FILENAME%
echo ^<explorer view="C:\ProgramData\PureBasic\Examples\" pattern="0"/^> >> %PROJECT_FILENAME%
echo ^<log show="1"/^> >> %PROJECT_FILENAME%
echo ^<lastopen date="2020-01-01 00:00:00" user="NOBODY" host="NONE"/^> >> %PROJECT_FILENAME%
echo ^</section^> >> %PROJECT_FILENAME%
echo ^<section name="files"^> >> %PROJECT_FILENAME%
echo ^<file name="Game.pb" ^> >> %PROJECT_FILENAME%
echo ^<config load="0" scan="1" panel="1" warn="1" lastopen="1" panelstate="+"/^> >> %PROJECT_FILENAME%
echo ^<fingerprint md5="abc123"/^> >> %PROJECT_FILENAME%
echo ^</file ^> >> %PROJECT_FILENAME%
for /f "delims=" %%a in ('dir /b /a:-D /s Framework') do (
	echo ^<file name="%%a" ^> >> %PROJECT_FILENAME%
	echo ^<config load="0" scan="1" panel="1" warn="1" lastopen="0" panelstate="+"/^> >> %PROJECT_FILENAME%
	echo ^<fingerprint md5="abc123"/^> >> %PROJECT_FILENAME%
	echo ^</file ^> >> %PROJECT_FILENAME%
)
for /f "delims=" %%a in ('dir /b /a:-D /s Game') do (
	echo ^<file name="%%a" ^> >> %PROJECT_FILENAME%
	echo ^<config load="0" scan="1" panel="1" warn="1" lastopen="0" panelstate="+"/^> >> %PROJECT_FILENAME%
	echo ^<fingerprint md5="abc123"/^> >> %PROJECT_FILENAME%
	echo ^</file ^> >> %PROJECT_FILENAME%
)
:: TODO: If build launcher, scan files
echo ^</section^> >> %PROJECT_FILENAME%
echo ^<section name="targets"^> >> %PROJECT_FILENAME%
if defined PROJECT_X64_TOGGLE (
	if "%PROJECT_X64_TOGGLE%" == "1" (
		if defined PROJECT_X64_COMPILER_NAME (
			if defined PROJECT_X64_DEFAULT (
				if "%PROJECT_X64_DEFAULT%" == "1" (
					echo ^<target name="x64" enabled="1" default="1"^> >> %PROJECT_FILENAME%
				) else (
					echo ^<target name="x64" enabled="1" default="0"^> >> %PROJECT_FILENAME%
				)
			) else (
				echo ^<target name="x64" enabled="1" default="0"^> >> %PROJECT_FILENAME%
			)
			echo ^<inputfile value="Game.pb"/^> >> %PROJECT_FILENAME%
			echo ^<outputfile value="Game-x64.exe"/^> >> %PROJECT_FILENAME%
			echo ^<compiler version="%PROJECT_X64_COMPILER_NAME%"/^> >> %PROJECT_FILENAME%
			echo ^<executable value="Game-x64.exe"/^> >> %PROJECT_FILENAME%
			echo ^<options xpskin="1" debug="1"/^> >> %PROJECT_FILENAME%
			echo ^<temporaryexe value="source"/^> >> %PROJECT_FILENAME%
			::echo ^<icon enable="1">icon.ico</icon^> >> %PROJECT_FILENAME%
			echo ^<compilecount enable="1" value="0"/^> >> %PROJECT_FILENAME%
			echo ^<buildcount enable="1" value="0"/^> >> %PROJECT_FILENAME%
			call :module-constant-parser
			echo ^</target^> >> %PROJECT_FILENAME%
		)
	)
)
if defined PROJECT_X86_TOGGLE (
	if "%PROJECT_X86_TOGGLE%" == "1" (
		if defined PROJECT_X86_COMPILER_NAME (
			if defined PROJECT_X86_DEFAULT (
				if "%PROJECT_X86_DEFAULT%" == "1" (
					echo ^<target name="x86" enabled="1" default="1"^> >> %PROJECT_FILENAME%
				) else (
					echo ^<target name="x86" enabled="1" default="0"^> >> %PROJECT_FILENAME%
				)
			) else (
				echo ^<target name="x86" enabled="1" default="0"^> >> %PROJECT_FILENAME%
			)
			echo ^<inputfile value="Game.pb"/^> >> %PROJECT_FILENAME%
			echo ^<outputfile value="Game-x86.exe"/^> >> %PROJECT_FILENAME%
			echo ^<compiler version="%PROJECT_X86_COMPILER_NAME%"/^> >> %PROJECT_FILENAME%
			echo ^<executable value="Game-x86.exe"/^> >> %PROJECT_FILENAME%
			echo ^<options xpskin="1" debug="1"/^> >> %PROJECT_FILENAME%
			echo ^<temporaryexe value="source"/^> >> %PROJECT_FILENAME%
			::echo ^<icon enable="1">icon.ico</icon^> >> %PROJECT_FILENAME%
			echo ^<compilecount enable="1" value="0"/^> >> %PROJECT_FILENAME%
			echo ^<buildcount enable="1" value="0"/^> >> %PROJECT_FILENAME%
			call :module-constant-parser
			echo ^</target^> >> %PROJECT_FILENAME%
		)
	)
)
echo ^</section^> >> %PROJECT_FILENAME%
echo ^</project^> >> %PROJECT_FILENAME%
echo. >> %PROJECT_FILENAME%
echo Done !
echo.
goto end


:module-constant-parser
echo ^<constants^> >> %PROJECT_FILENAME%
if defined FRAMEWORK_MODULE_XINPUT (
	if "%FRAMEWORK_MODULE_XINPUT%" == "1" (
		echo ^<constant value="#FRAMEWORK_MODULE_XINPUT = #True" enable="1"/^> >> %PROJECT_FILENAME%
	) else (
		echo ^<constant value="#FRAMEWORK_MODULE_XINPUT = #False" enable="1"/^> >> %PROJECT_FILENAME%
	)
) else (
	echo ^<constant value="#FRAMEWORK_MODULE_XINPUT = #False" enable="1"/^> >> %PROJECT_FILENAME%
)
if defined FRAMEWORK_MODULE_SNAPPY (
	if "%FRAMEWORK_MODULE_SNAPPY%" == "1" (
		echo ^<constant value="#FRAMEWORK_MODULE_SNAPPY = #True" enable="1"/^> >> %PROJECT_FILENAME%
	) else (
		echo ^<constant value="#FRAMEWORK_MODULE_SNAPPY = #False" enable="1"/^> >> %PROJECT_FILENAME%
	)
) else (
	echo ^<constant value="#FRAMEWORK_MODULE_SNAPPY = #False" enable="1"/^> >> %PROJECT_FILENAME%
)
if defined FRAMEWORK_MODULE_ARGUMENTS (
	if "%FRAMEWORK_MODULE_ARGUMENTS%" == "1" (
		echo ^<constant value="#FRAMEWORK_MODULE_ARGUMENTS = #True" enable="1"/^> >> %PROJECT_FILENAME%
	) else (
		echo ^<constant value="#FRAMEWORK_MODULE_ARGUMENTS = #False" enable="1"/^> >> %PROJECT_FILENAME%
	)
) else (
	echo ^<constant value="#FRAMEWORK_MODULE_ARGUMENTS = #False" enable="1"/^> >> %PROJECT_FILENAME%
)
echo ^</constants^> >> %PROJECT_FILENAME%
goto:eof


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
