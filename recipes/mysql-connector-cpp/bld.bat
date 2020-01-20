dir "C:\Program Files (x86)\MSBuild\Microsoft.Cpp\v4.0\V140\"
dir "C:\Program Files (x86)\MSBuild\Microsoft.Cpp\v4.0"
dir "C:\Program Files (x86)\MSBuild\Microsoft.Cpp\"
dir "C:\Program Files (x86)\MSBuild\"
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

set VCTargetsPath="C:\Program Files (x86)\MSBuild\Microsoft.Cpp\v4.0\V140"

for %%O in (ON OFF) DO ( 
   cmake -S. ^
     -Bbuild.%%O ^
     -DBUILD_STATIC=%%O ^
     -G"%CMAKE_GENERATOR%" ^
     -DCMAKE_INSTALL_LIBDIR=lib ^
     -DWITH_SSL=%LIBRARY_PREFIX% ^
     -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON ^
     -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
     -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX%
     REM -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON ^
   if ERRORLEVEL 1 EXIT 1

   cmake --build build.%%O --config Release --target install
   if ERRORLEVEL 1 EXIT 1
)

move %LIBRARY_PREFIX%\INFO_SRC %LIBRARY_PREFIX%\%PKG_NAME%_INFO_SRC
move %LIBRARY_PREFIX%\INFO_BIN %LIBRARY_PREFIX%\%PKG_NAME%_INFO_BIN
