@ECHO off

PUSHD %~dp0

@IF EXIST submodules/zlib/zconf.g GOTO BUILD_LIBPNG

:BUILD_ZLIB
call build_zlib.bat
@IF NOT %ERRORLEVEL% EQU 0 ( @EXIT /b %ERRORLEVEL% )

:BUILD_LIBPNG
cd submodules/libpng

@IF EXIST .build GOTO HAS_CONFIG
mkdir .build
cd .build
@SET "CMAKE_MSVC_RUNTIME_LIBRARY=MultiThreadedDebug"
cmake ../. -G"Visual Studio 16 2019" -Ax64 -Thost=x64 -DZLIB_LIBRARY="../../zlib/.build/Release/zlibstatic" -DZLIB_INCLUDE_DIR="../../zlib" -DMSVC_RUNTIME=static

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
@ECHO SUCCESS!
@POPD
@EXIT /b 0

:HADERROR
@ECHO.
@ECHO  [31m=================FAILED=================[0m
@POPD
rd /s /q ./.build
@EXIT /b %ERRORLEVEL%
