@echo off

if        "%1" == "debug"   ( goto :DEBUG
) else if "%1" == "release" ( goto :RELEASE
) else (
  echo Usage:
  echo     $ make.cmd [debug, release]
  goto :EOF
)

:DEBUG
  odin build . -debug
goto :EOF

:RELEASE
  odin build . -o:speed
goto :EOF

REM vim: foldmethod=marker ft=dosbatch fenc=cp932 ff=dos
