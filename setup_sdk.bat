@echo off
echo ==========================================
echo      Downloading Flutter SDK...
echo ==========================================
echo.
echo This will download the Flutter SDK to this folder.
echo It is required to run the game since we couldn't find it on your PC.
echo.
echo Downloading (this may take a few minutes)...
git clone https://github.com/flutter/flutter.git -b stable --depth 1 flutter_sdk

if exist "flutter_sdk\bin\flutter.bat" (
    echo.
    echo [✓] Flutter downloaded successfully!
    echo.
    echo Now you can run: run_game.bat
) else (
    echo.
    echo [X] Download failed. Please check your internet connection.
)
pause
