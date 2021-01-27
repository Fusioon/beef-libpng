@ECHO off

PUSHD %~dp0

cd submodules/zlib

@IF EXIST zlib_build GOTO HAS_CONFIG
@copy ..\\CMakeLists_zlib.txt .\\CMakeLists.txt /V /Y
mkdir .build
cd .build
cmake ../. -G"Visual Studio 16 2019" -Ax64 -Thost=x64 -DMSVC_STATIC_LIB="OFF"
@GOTO DOBUILD

:HAS_CONFIG
cd .build
@GOTO DOBUILD

:DOBUILD
cmake --build . --config Debug 
cmake --build . --config Release 

@IF %ERRORLEVEL% EQU 0 (
   GOTO SUCCESS
) else (
   GOTO HADERROR
)

:SUCCESS
@copy zconf.h ../zconf.h /V /Y
@ECHO SUCCESS!
@POPD
@EXIT /b 0

:HADERROR
@ECHO.
@ECHO  [31m=================FAILED=================[0m
@POPD
rd /s /q ./.build
@EXIT /b %ERRORLEVEL%
