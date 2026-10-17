@echo off
setlocal
cd /d "%~dp0"

echo ==========================================
echo ERFAN OXIGEN - Flutter Android Setup
echo ==========================================
echo.

where flutter >nul 2>&1
if errorlevel 1 (
  echo Flutter was not found in PATH.
  echo Please open PowerShell where "flutter --version" works.
  pause
  exit /b 1
)

echo [1/4] Creating/updating modern Flutter Android project...
flutter create --platforms=android .
if errorlevel 1 (
  echo Flutter project generation failed.
  pause
  exit /b 1
)

echo [2/4] Applying compatible Gradle configuration...
copy /Y "_android_fixed\settings.gradle" "android\settings.gradle" >nul
copy /Y "_android_fixed\build.gradle" "android\build.gradle" >nul
copy /Y "_android_fixed\app\build.gradle" "android\app\build.gradle" >nul
copy /Y "_android_fixed\gradle.properties" "android\gradle.properties" >nul

echo [3/4] Getting packages...
flutter clean
flutter pub get
if errorlevel 1 (
  echo Package installation failed.
  pause
  exit /b 1
)

echo [4/4] Starting the app...
flutter run

endlocal
