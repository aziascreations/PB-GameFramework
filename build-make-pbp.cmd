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
del %PROJECT_FILENAME%
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
echo ^<config load="0" scan="1" panel="1" warn="1" lastopen="0" panelstate="+"/^> >> %PROJECT_FILENAME%
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
echo ^</section^> >> %PROJECT_FILENAME%

echo ^</project^> >> %PROJECT_FILENAME%
echo. >> %PROJECT_FILENAME%
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
