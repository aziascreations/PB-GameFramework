@echo off

set PATH=%PATH%;C:\Program Files\7-Zip

rmdir /Q /S Packages\
del .\*.exe
mkdir Packages\

7z a ./Packages/Game.zip ./Build/*
7z a ./Packages/Game.7z ./Build/*

7z a ./Packages/Game-sources.zip ./Data ./Engine ./Game ./Licenses ./*.cmd ./*.pb ./*.pb.cfg ./*ico ./*.dll ./LICENSE ./readme.md
7z a ./Packages/Game-sources.7z ./Data ./Engine ./Game ./Licenses ./*.cmd ./*.pb ./*.pb.cfg ./*ico ./*.dll ./LICENSE ./readme.md

pause
