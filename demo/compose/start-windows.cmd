@echo off
setlocal

where docker >nul 2>&1
if errorlevel 1 (
  echo Docker is not installed or is not in PATH.
  exit /b 1
)

if "%~1"=="" (
  docker compose --project-directory "%~dp0." -f "%~dp0compose.yaml" up --detach --pull always --no-build
) else (
  docker compose --project-directory "%~dp0." -f "%~dp0compose.yaml" %*
)
exit /b %errorlevel%
