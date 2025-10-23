@echo off

::SQL FIELDS
set USER=sa
set PASSWORD=sapassword
set SERVER=SERVER\INSTANCE
set DB=DATABASE_NAME

::FILE PATH FIELDS
for /f "tokens=2 delims==" %%i in ('wmic os get localdatetime /value') do set DATE=%%i
set DATE=%DATE:~0,8%
set BACKUP_PATH=D:\FOLDER\OUTPUT
set FILE_NAME=SERVER_NAME_%DB%_%DATE%.bak

::CHECK IF THE FOLDER EXISTS
IF NOT EXIST "%BACKUP_PATH%" (MKDIR "%BACKUP_PATH%")

::CONSOLE PRINTS
echo CREATING A DB BACKUP
echo Server\Instance:%SERVER%
echo Database: %DB%
echo User: %USER%
echo File Path: %BACKUP_PATH%\%FILE_NAME%

::¡DO NOT MODIFY!
sqlcmd -S %SERVER% -U %USER% -P %PASSWORD% -Q "BACKUP DATABASE [%DB%] TO DISK = N'%BACKUP_PATH%\%FILE_NAME%' WITH FORMAT, INIT, NAME = N'%DB% backup completed', SKIP, NOREWIND, NOUNLOAD, STATS = 10"

