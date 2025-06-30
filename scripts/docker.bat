@echo off
setlocal enabledelayedexpansion

REM Docker management script for kuber-test (Windows)

set "SCRIPT_NAME=%~n0"

REM Function to show usage
:show_usage
echo Usage: %SCRIPT_NAME% [COMMAND]
echo.
echo Commands:
echo   build       Build production Docker image
echo   build-dev   Build development Docker image
echo   run         Run production container
echo   run-dev     Run development container
echo   stop        Stop all containers
echo   clean       Remove all containers and images
echo   logs        Show container logs
echo   shell       Open shell in running container
echo   help        Show this help message
goto :eof

REM Function to build production image
:build_production
echo [INFO] Building production Docker image...
docker build -t kuber-test:latest .
if %ERRORLEVEL% EQU 0 (
    echo [INFO] Production image built successfully!
) else (
    echo [ERROR] Failed to build production image!
)
goto :eof

REM Function to build development image
:build_development
echo [INFO] Building development Docker image...
docker build -f Dockerfile.dev -t kuber-test:dev .
if %ERRORLEVEL% EQU 0 (
    echo [INFO] Development image built successfully!
) else (
    echo [ERROR] Failed to build development image!
)
goto :eof

REM Function to run production container
:run_production
echo [INFO] Starting production container...
docker run -d --name kuber-test-prod -p 3000:3000 kuber-test:latest
if %ERRORLEVEL% EQU 0 (
    echo [INFO] Production container started on http://localhost:3000
) else (
    echo [ERROR] Failed to start production container!
)
goto :eof

REM Function to run development container
:run_development
echo [INFO] Starting development container...
docker run -d --name kuber-test-dev -p 3001:3000 -v %cd%:/app -v /app/node_modules kuber-test:dev
if %ERRORLEVEL% EQU 0 (
    echo [INFO] Development container started on http://localhost:3001
) else (
    echo [ERROR] Failed to start development container!
)
goto :eof

REM Function to stop containers
:stop_containers
echo [INFO] Stopping containers...
docker stop kuber-test-prod kuber-test-dev 2>nul
docker rm kuber-test-prod kuber-test-dev 2>nul
echo [INFO] Containers stopped and removed!
goto :eof

REM Function to clean everything
:clean_all
echo [WARNING] This will remove all containers and images. Are you sure? (y/N)
set /p response=
if /i "!response!"=="y" (
    echo [INFO] Cleaning up...
    docker stop $(docker ps -aq) 2>nul
    docker rm $(docker ps -aq) 2>nul
    docker rmi kuber-test:latest kuber-test:dev 2>nul
    echo [INFO] Cleanup completed!
) else (
    echo [INFO] Cleanup cancelled.
)
goto :eof

REM Function to show logs
:show_logs
docker ps | findstr kuber-test-prod >nul
if %ERRORLEVEL% EQU 0 (
    echo [INFO] Showing production container logs...
    docker logs -f kuber-test-prod
) else (
    docker ps | findstr kuber-test-dev >nul
    if %ERRORLEVEL% EQU 0 (
        echo [INFO] Showing development container logs...
        docker logs -f kuber-test-dev
    ) else (
        echo [ERROR] No running containers found!
    )
)
goto :eof

REM Function to open shell
:open_shell
docker ps | findstr kuber-test-prod >nul
if %ERRORLEVEL% EQU 0 (
    echo [INFO] Opening shell in production container...
    docker exec -it kuber-test-prod /bin/sh
) else (
    docker ps | findstr kuber-test-dev >nul
    if %ERRORLEVEL% EQU 0 (
        echo [INFO] Opening shell in development container...
        docker exec -it kuber-test-dev /bin/sh
    ) else (
        echo [ERROR] No running containers found!
    )
)
goto :eof

REM Main script logic
if "%1"=="" goto show_usage
if "%1"=="help" goto show_usage
if "%1"=="build" goto build_production
if "%1"=="build-dev" goto build_development
if "%1"=="run" (
    call :stop_containers
    call :run_production
    goto :eof
)
if "%1"=="run-dev" (
    call :stop_containers
    call :run_development
    goto :eof
)
if "%1"=="stop" goto stop_containers
if "%1"=="clean" goto clean_all
if "%1"=="logs" goto show_logs
if "%1"=="shell" goto open_shell

echo [ERROR] Unknown command: %1
call :show_usage 