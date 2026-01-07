@echo off
cd /d "%~dp0"
echo ==========================================
echo      Sequence Logic - Web Launcher
echo ==========================================

:: Set mirrors to bypass network blocking
set "PUB_HOSTED_URL=https://pub.flutter-io.cn"
set "FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn"

:: 0. Check for local SDK (setup_sdk.bat)
if exist "%~dp0flutter_sdk\bin\flutter.bat" (
    echo [✓] Found local Flutter SDK.
    set "FLUTTER_ROOT=%~dp0flutter_sdk"
    goto :set_path
)

:: 1. Check if flutter is already in PATH
where flutter >nul 2>nul
if %errorlevel% equ 0 (
    echo [✓] Flutter found in PATH.
    goto :run_app
)

:: 2. Check common locations
set "candidate_paths=C:\src\flutter C:\flutter D:\src\flutter D:\flutter %USERPROFILE%\flutter %LOCALAPPDATA%\flutter"

for %%p in (%candidate_paths%) do (
    if exist "%%p\bin\flutter.bat" (
        echo [✓] Found Flutter at: %%p
        set "FLUTTER_ROOT=%%p"
        goto :set_path
    )
)

:set_path
set "PATH=%PATH%;%FLUTTER_ROOT%\bin"

:run_app
echo.
echo [+] Launching Sequence Logic in Chrome...
call flutter run -d chrome

pause
