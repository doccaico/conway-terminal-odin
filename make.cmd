@echo off

set PRG=conway-terminal-odin.exe

if        "%1" == "debug"       ( goto :DEBUG
) else if "%1" == "release"     ( goto :RELEASE
) else if "%1" == "debug-run"   ( goto :DEBUG_RUN
) else if "%1" == "release-run" ( goto :RELEASE_RUN
) else (
  echo Usage:
  echo     $ make.cmd [debug, release, debug-run, release-run]
  goto :EOF
)

:DEBUG
  odin build . -debug
goto :EOF

:RELEASE
  odin build . -o:speed
goto :EOF

:DEBUG_RUN
  odin build . -debug
  call :run
goto :EOF

:RELEASE_RUN
  odin build . -o:speed
  call :run
goto :EOF

:run
  if %ERRORLEVEL% equ 0 (
    %PRG%
  )
exit /b

REM vim: foldmethod=marker ft=dosbatch fenc=cp932 ff=dos
