@echo off
REM     v1.1  
REM  Argument list: 
REM   -- input folder (relative paths supported)             -- %1
REM   -- output folder (relative paths supported)            -- %2
REM   -- filepath to json profile (relative paths supported) -- %3
REM   -- 
REM   -- Note 1: The code does not create the output folder if it does not already exist
REM


if "%3"=="" (
   echo Error: Incorrect number of arguments
   echo RunPDFOptimizer.bat inputFolder outputFolder profilePath
   echo   example: RunPDFOptimizer.bat  c:\test\input\  c:\test\output\  c:\datalogics\pdfoptimizer\OptimizationProfiles\standard.json
   GOTO:eof
)

REM set the eval license path if needed
SET RLM_LICENSE=c:\datalogics\PDFOptimizer\
REM -- the "enableddelayedexpansion" is required to use the set variable names in a loop. Use !var! rather than %var%
setlocal enabledelayedexpansion

set /a pdfcount=0
set /a succescount=0
set /a failcount=0

REM echo input folder is: %1
REM echo output folder is: %2
REM echo json is: %3
set json=%3

for %%V in (%1%\*.*) do (
   set "fullname=%%V"
   set drive=%%~dV
   set fname=%%~nxV
   set basefname=%%~nV
   set folderpath=%%~dpV
   set fpath=%%~pV
   set ext=%%~xV
   
   REM echo fullname: !fullname!
   REM echo drive: !drive!    
   REM echo basefname: !basefname!
   REM echo fname: !fname! 
   REM echo folderpath: !folderpath!
   REM echo fpath: !fpath!
   REM echo ext: !ext!
    
   if !ext! == .pdf (
      set /a pdfcount=!pdfcount!+1
      echo processing file !fname!
      pdfoptimizer !fullname! %2%\!fname! !json!
      REM if %ERRORLEVEL% EQU 0 (
      if ERRORLEVEL 1 (
             set /a failcount=!failcount!+1
      ) else (
             set /a successcount=!successcount!+1
      )
   ) else (
       echo skiping file !fname!
   )
)

REM
echo Finished: Processed !pdfcount! PDF files, !successcount! succeeded, !failcount! failed 
REM