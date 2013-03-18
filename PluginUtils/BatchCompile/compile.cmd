@ECHO off

SET todoDir=%~d0%~p0todo
SET doneDir=%~d0%~p0done
SET logDir=%~d0%~p0messages
SET tempDir=%~d0%~p0temp

SET mkplugin=%~d0%~p0mkplugin.exe
SET msbuild="C:\Windows\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe"

FOR /F %%a IN ('DIR /b "%doneDir%\*.dll"') DO (
	DEL /Q "%doneDir%\%%a" > NUL
)

MKDIR "%tempDir%"

FOR /F %%a IN ('DIR /b "%todoDir%\*.c"') DO (
	REM Generate VC++ project

	"%mkplugin%" "%%~na" "%tempDir%\%%~na" > NUL
	ATTRIB -H "%tempDir%\%%~na\plugin.h" > NUL
	REN "%tempDir%\%%~na\plugin.h" "apoplugin.h" > NUL
	COPY /Y "%todoDir%\%%a" "%tempDir%\%%~na\%%~na.cpp" > NUL
	
	REM Compile "x86"
	
	%msbuild% /nologo /verbosity:quiet /p:Configuration=Release;Platform=Win32 "%tempDir%\%%~na\%%~na.vcxproj" > "%logDir%\%%~na.x86.log"
	IF EXIST "%tempDir%\%%~na\bin\x86\%%~na.dll" (
		COPY /Y "%tempDir%\%%~na\bin\x86\%%~na.dll" "%doneDir%\%%~na.x86.dll" > NUL
		ECHO SUCCESS: "%%~na.x86"
		DEL /Q "%logDir%\%%~na.x86.log" > NUL
	)
	IF NOT EXIST "%tempDir%\%%~na\bin\x86\%%~na.dll" ECHO ERROR: "%%~na.x86" - see "%logDir%\%%~na.x86.log" for details!
	
	REM Compile "x64"
	
	%msbuild% /nologo /verbosity:quiet /p:Configuration=Release;Platform=x64 "%tempDir%\%%~na\%%~na.vcxproj" > "%logDir%\%%~na.x64.log"
	IF EXIST "%tempDir%\%%~na\bin\x64\%%~na.dll" (
		COPY /Y "%tempDir%\%%~na\bin\x64\%%~na.dll" "%doneDir%\%%~na.x64.dll" > NUL
		ECHO SUCCESS: "%%~na.x64"
		DEL /Q "%logDir%\%%~na.x64.log" > NUL
	)
	IF NOT EXIST "%tempDir%\%%~na\bin\x64\%%~na.dll" ECHO ERROR: "%%~na.x64" - see "%logDir%\%%~na.x64.log" for details!
	
	REM Clean up
	
	RMDIR /S /Q "%tempDir%\%%~na" > NUL
)

RMDIR /S /Q "%tempDir%"