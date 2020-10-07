@echo off

set PATH=%PATH%;C:\Program Files\7-Zip

rmdir /Q /S Packages\
del .\*.exe
mkdir Packages\

7z a -mx9 ./Packages/Game.zip ./Build/*
7z a -mx9 ./Packages/Game.7z ./Build/*

:: TODO: filter out the exes that may appear in the source code folders when testing out stuff.
7z a -mx9 ./Packages/Game-sources.zip ./Data ./Engine ./Game ./Licenses ./*.cmd ./*.pb ./*.pb.cfg ./*ico ./*.dll ./LICENSE ./readme.md ./*.pbp
7z a -mx9 ./Packages/Game-sources.7z ./Data ./Engine ./Game ./Licenses ./*.cmd ./*.pb ./*.pb.cfg ./*ico ./*.dll ./LICENSE ./readme.md ./*.pbp

pause
