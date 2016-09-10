@echo off

rem http://stackoverflow.com/questions/5034076/what-does-dp0-mean-and-how-does-it-work
rem http://stackoverflow.com/questions/112055/what-does-d0-mean-in-a-windows-batch-file
rem http://stackoverflow.com/questions/130116/windows-batch-commands-to-read-first-line-from-text-file

rem ----------------------------------------------------------------------

rem http://justinsomnia.org/2007/02/how-to-regularly-backup-windows-xp-to-ubuntu-using-rsync/

set drive=%~d0
set driveLetter=%drive:~0,1%

if (%drive%) == () goto driveNotFound
if (%driveLetter%) == () goto driveNotFound

set hour=%TIME:~0,2%
if "%hour:~0,1%" == " " set hour=0%hour:~1,1%
set bdir=%DATE:~-4%-%DATE:~3,2%-%DATE:~0,2%_%hour%%TIME:~3,2%

set linkArgument=
set lastBackup=
for /F %%G in ('dir /b /on %drive%\backup\20*-*-*_*') do set lastBackup=%%G
if (%lastBackup%) == () goto noLastBackup
set linkArgument=--link-dest=/cygdrive/%driveLetter%/backup/%lastBackup%
:noLastBackup

echo Starting backup ...
echo Drive ... %drive%
echo Backup Directory ... %bdir%
echo Link Argument ... %linkArgument%

d:\cygwin64\bin\rsync.exe --archive --verbose --modify-window=1 %linkArgument% --exclude-from=/cygdrive/%driveLetter%/backup/backup_exclude.txt /cygdrive/c/users "/cygdrive/c/World of Warcraft" "/cygdrive/d/Ralph Musik" /cygdrive/d/Daggerfall /cygdrive/%driveLetter%/backup/%bdir%

echo Backup done

goto end

:driveNotFound
echo "Could not get drive letter"
goto end

:end

pause
