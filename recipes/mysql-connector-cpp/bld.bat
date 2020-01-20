@echo ON

GOTO THEREALDEAL

dir "C:\Program Files (x86)\MSBuild\Microsoft.Cpp\v4.0\V140\"
dir "C:\Program Files (x86)\MSBuild\Microsoft.Cpp\v4.0\"
dir "C:\Program Files (x86)\MSBuild\Microsoft.Cpp\"
dir "C:\Program Files (x86)\MSBuild\"
dir "C:\Program Files (x86)\MSBuild\15.0\"
dir "C:\Program Files (x86)\MSBuild\Microsoft\"
dir "C:\Program Files (x86)\"


where msbuild
echo "WTF is going on?"
dir "%VCINSTALLDIR%\"
dir "%VCINSTALLDIR%\IDE"
dir "%VCINSTALLDIR%\IDE\VC"
dir "%VCINSTALLDIR%\IDE\VC\VCTargets"


dir %VCINSTALLDIR%\
dir %VCINSTALLDIR%\IDE
dir %VCINSTALLDIR%\IDE\VC
dir %VCINSTALLDIR%\IDE\VC\VCTargets

set

:THEREALDEAL

SETLOCAL ENABLEDELAYEDEXPANSION
SET "MSBUILD_LOCATION=MSBuild.exe"

for /D %%A IN ("%PROGRAMFILES(X86)%\Microsoft Visual Studio\*") DO (
  for /D %%B IN ("%%~A\*") DO (
    for /D %%C IN ("%%~B\MSBuild\*") DO (
      SET "_POTENTIAL_MSBUILD_CANDIDATE=%%C\bin\msbuild.exe"
      if EXIST "!_POTENTIAL_MSBUILD_CANDIDATE!" (
 SET "MSBUILD_LOCATION=!_POTENTIAL_MSBUILD_CANDIDATE!"
 SET "VCTargetsPath=%%~B\Common7\IDE\VC\VCTargets"
        GOTO STOP_MSBUILD_SEARCH
      )
    )
  )
)

for /D %%A IN ("%PROGRAMFILES(X86)%\MSbuild\*") DO (
  SET "_POTENTIAL_MSBUILD_CANDIDATE=%%A\bin\msbuild.exe"
  if EXIST "!_POTENTIAL_MSBUILD_CANDIDATE!" (
    SET "MSBUILD_LOCATION=!_POTENTIAL_MSBUILD_CANDIDATE!"
    SET "VCTargetsPath=C:\Program Files (x86)\MSBuild\Microsoft.Cpp\v4.0\V140"
    GOTO STOP_MSBUILD_SEARCH
  )
)

:STOP_MSBUILD_SEARCH

echo 'wtf is going on?'
echo !MSBUILD_LOCATION!
echo %VCTargetsPath%

for %%O in (ON OFF) DO ( 
   cmake -S. ^
     -Bbuild.%%O ^
     -DBUILD_STATIC=%%O ^
     -G"%CMAKE_GENERATOR%" ^
     -DCMAKE_INSTALL_LIBDIR=lib ^
     -DWITH_SSL=%LIBRARY_PREFIX% ^
     -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON ^
     -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
     -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
     -DCMAKE_MAKE_PROGRAM="!MSBUILD_LOCATION!"
     REM -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON ^
   if ERRORLEVEL 1 EXIT 1

   cmake --build build.%%O --config Release --target install
   if ERRORLEVEL 1 EXIT 1
)

move %LIBRARY_PREFIX%\INFO_SRC %LIBRARY_PREFIX%\%PKG_NAME%_INFO_SRC
move %LIBRARY_PREFIX%\INFO_BIN %LIBRARY_PREFIX%\%PKG_NAME%_INFO_BIN
