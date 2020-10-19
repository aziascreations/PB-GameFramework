@echo off
echo Cleaning...
rmdir /Q /S Build\
rmdir /Q /S Packages\
del .\*.exe
del .\*.asm
del .\*.ini
del /S *.pb.cfg
del /S *.pbi.cfg
del /S *.pbf.cfg
del /S *.pbp.cfg
exit /B
