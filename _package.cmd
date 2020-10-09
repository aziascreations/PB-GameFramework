@echo off
chcp 65001 >nul
echo ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
echo ┃ Automated packaging script v1.0 ┃
echo ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
set PATH=%PATH%;C:\Program Files\7-Zip
set APPNAME=GameTest
echo.

echo ━┫ Preliminary clean-up ┣━
rmdir /Q /S Packages\
del .\*.exe
echo.

echo ━┫ Environment setup ┣━
mkdir Packages\
echo.

echo ━┫ Packaging application ┣━
7z a -mx9 ./Packages/%APPNAME%-x64.zip ./Build/x64/*
7z a -mx9 ./Packages/%APPNAME%-x86.zip ./Build/x86/*
7z a -mx9 ./Packages/%APPNAME%-x64.7z ./Build/x64/*
7z a -mx9 ./Packages/%APPNAME%-x86.7z ./Build/x86/*
7z a -mx9 ./Packages/%APPNAME%-x64.tar ./Build/x64/*
7z a -mx9 ./Packages/%APPNAME%-x64.tar.gz ./Packages/%APPNAME%-x64.tar
7z a -mx9 ./Packages/%APPNAME%-x86.tar ./Build/x86/*
7z a -mx9 ./Packages/%APPNAME%-x86.tar.gz ./Packages/%APPNAME%-x86.tar
echo.

echo ━┫ Packaging source code ┣━
:: TODO: filter out the exes that may appear in the source code folders when testing out stuff.
7z a -mx9 ./Packages/%APPNAME%-sources.zip ./Data ./Engine ./Game ./Libraries ./Licenses ./*.cmd ./*.pb ./*.pb.cfg ./*ico ./LICENSE ./readme.md ./*.pbp ./.gitignore
7z a -mx9 ./Packages/%APPNAME%-sources.7z ./Data ./Engine ./Game ./Libraries ./Licenses ./*.cmd ./*.pb ./*.pb.cfg ./*ico ./LICENSE ./readme.md ./*.pbp ./.gitignore
7z a -mx9 ./Packages/%APPNAME%-sources.tar ./Data ./Engine ./Game ./Libraries ./Licenses ./*.cmd ./*.pb ./*.pb.cfg ./*ico ./LICENSE ./readme.md ./*.pbp ./.gitignore
7z a -mx9 ./Packages/%APPNAME%-sources.tar.gz ./Packages/%APPNAME%-sources.tar
echo.

echo ━┫ Packaging repository ┣━
7z a -mx9 ./Packages/%APPNAME%-sources+git.zip ./Data ./Engine ./Game ./Libraries ./Licenses ./*.cmd ./*.pb ./*.pb.cfg ./*ico ./LICENSE ./readme.md ./*.pbp ./.gitignore ./.git
7z a -mx9 ./Packages/%APPNAME%-sources+git.7z ./Data ./Engine ./Game ./Libraries ./Licenses ./*.cmd ./*.pb ./*.pb.cfg ./*ico ./LICENSE ./readme.md ./*.pbp ./.gitignore ./.git
7z a -mx9 ./Packages/%APPNAME%-sources+git.tar ./Data ./Engine ./Game ./Libraries ./Licenses ./*.cmd ./*.pb ./*.pb.cfg ./*ico ./LICENSE ./readme.md ./*.pbp ./.gitignore ./.git
7z a -mx9 ./Packages/%APPNAME%-sources+git.tar.gz ./Packages/%APPNAME%-sources+git.tar
echo.

pause
