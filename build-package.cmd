@echo off
chcp 65001 >nul
echo ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
echo ┃ Automated packaging script v2.0 ┃
echo ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
echo.
goto package-settings


:package-settings
echo ━┫ Internal settings ┣━
call build-config
if defined PACKAGE_APP_NAME (
	if "%PACKAGE_APP_NAME%" == "" (
		set PACKAGE_APP_NAME=CONFIG-ERROR-EMPTY
	)
) else (
	set PACKAGE_APP_NAME=CONFIG-ERROR-UNDEFINED
)
echo Done !
echo.
goto package-clean


:package-clean
echo ━┫ Preliminary clean-up ┣━
rmdir /Q /S Packages\
del .\*.exe
echo Done !
echo.
goto package-setup


:package-setup
echo ━┫ Environment setup ┣━
mkdir Packages\
echo Done !
echo.
goto package-package


:package-package
echo ━┫ Packaging application ┣━
%ZIPEXE% a -mx9 "./Packages/%PACKAGE_APP_NAME%-x64.zip" ./Build/x64/*
%ZIPEXE% a -mx9 "./Packages/%PACKAGE_APP_NAME%-x86.zip" ./Build/x86/*
%ZIPEXE% a -mx9 "./Packages/%PACKAGE_APP_NAME%-x64.7z" ./Build/x64/*
%ZIPEXE% a -mx9 "./Packages/%PACKAGE_APP_NAME%-x86.7z" ./Build/x86/*
%ZIPEXE% a -mx9 "./Packages/%PACKAGE_APP_NAME%-x64.tar" ./Build/x64/*
%ZIPEXE% a -mx9 "./Packages/%PACKAGE_APP_NAME%-x64.tar.gz" "./Packages/%PACKAGE_APP_NAME%-x64.tar"
%ZIPEXE% a -mx9 "./Packages/%PACKAGE_APP_NAME%-x86.tar" ./Build/x86/*
%ZIPEXE% a -mx9 "./Packages/%PACKAGE_APP_NAME%-x86.tar.gz" "./Packages/%PACKAGE_APP_NAME%-x86.tar"
echo Done !
echo.
echo ━┫ Packaging source code ┣━
:: TODO: filter out the exes that may appear in the source code folders when testing out stuff.
%ZIPEXE% a -mx9 "./Packages/%PACKAGE_APP_NAME%-sources.zip" ./Data ./Documentation ./Framework ./Game ./Libraries ./Launcher ./Licenses ./*.cmd ./*.pb ./*ico ./LICENSE ./readme.md ./*.pbp ./.gitignore
%ZIPEXE% a -mx9 "./Packages/%PACKAGE_APP_NAME%-sources.7z" ./Data ./Documentation ./Framework ./Game ./Libraries ./Launcher ./Licenses ./*.cmd ./*.pb ./*ico ./LICENSE ./readme.md ./*.pbp ./.gitignore
%ZIPEXE% a -mx9 "./Packages/%PACKAGE_APP_NAME%-sources.tar" ./Data ./Documentation ./Framework ./Game ./Libraries ./Launcher ./Licenses ./*.cmd ./*.pb ./*ico ./LICENSE ./readme.md ./*.pbp ./.gitignore
%ZIPEXE% a -mx9 "./Packages/%PACKAGE_APP_NAME%-sources.tar.gz" "./Packages/%PACKAGE_APP_NAME%-sources.tar"
echo Done !
echo.
goto end


:end
pause
