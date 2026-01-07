@echo off
setlocal
cd /d "%~dp0"
echo ==========================================
echo      Sequence Logic - Launcher
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

echo [!] Flutter not found in global PATH. 
echo [+] Searching common locations...

:: 2. Check common locations
set "candidate_paths=C:\src\flutter C:\flutter D:\src\flutter D:\flutter %USERPROFILE%\flutter %LOCALAPPDATA%\flutter"

for %%p in (%candidate_paths%) do (
    if exist "%%p\bin\flutter.bat" (
        echo [✓] Found Flutter at: %%p
        set "FLUTTER_ROOT=%%p"
        goto :set_path
    )
)

:: 3. If not found, ask user
echo.
echo [X] Could not find Flutter automatically.
echo.
echo Please locate your "flutter" folder and drag it into this window, then press Enter.
echo (Example: C:\src\flutter)
set /p USER_PATH="> "

:: Remove quotes if present
set USER_PATH=%USER_PATH:"=%

if exist "%USER_PATH%\bin\flutter.bat" (
    set "FLUTTER_ROOT=%USER_PATH%"
    goto :set_path
) else (
    echo.
    echo [ERROR] Could not find flutter.bat in "%USER_PATH%\bin".
    echo Please check the path and try again.
    pause
    exit /b
)

:set_path
echo [+] Adding Flutter to temporary PATH...
set "PATH=%PATH%;%FLUTTER_ROOT%\bin"

:run_app
echo.
echo [+] Installing dependencies...
call flutter pub get

echo.
echo [+] Launching Sequence Logic...
echo     (This may take a minute for the first build)
call flutter run -d windows

if %errorlevel% neq 0 (
    echo.
    echo [!] App exited with error level %errorlevel%.
    pause
) else (
    echo.
    echo [✓] App closed successfully.
    pause
)
endlocal
