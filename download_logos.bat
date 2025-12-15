@echo off
echo Downloading skill logos...
echo.
echo Creating skills directory if it doesn't exist...
if not exist "assets\images\skills" mkdir "assets\images\skills"

echo.
echo Please download the following logos manually:
echo.
echo 1. C logo (c.png)
echo    URL: https://cdn.jsdelivr.net/gh/devicons/devicon/icons/c/c-original.svg
echo.
echo 2. Docker logo (docker.png)
echo    URL: https://cdn.jsdelivr.net/gh/devicons/devicon/icons/docker/docker-original.svg
echo.
echo 3. JavaScript logo (js.png)
echo    URL: https://cdn.jsdelivr.net/gh/devicons/devicon/icons/javascript/javascript-original.svg
echo.
echo 4. Kotlin logo (kotlin.png)
echo    URL: https://cdn.jsdelivr.net/gh/devicons/devicon/icons/kotlin/kotlin-original.svg
echo.
echo 5. MySQL logo (mysql.png)
echo    URL: https://cdn.jsdelivr.net/gh/devicons/devicon/icons/mysql/mysql-original.svg
echo.
echo 6. PHP logo (php.png)
echo    URL: https://cdn.jsdelivr.net/gh/devicons/devicon/icons/php/php-original.svg
echo.
echo 7. Selenium logo (selenium.png)
echo    URL: https://cdn.jsdelivr.net/gh/devicons/devicon/icons/selenium/selenium-original.svg
echo.
echo.
echo INSTRUCTIONS:
echo 1. Visit each URL above
echo 2. Convert SVG to PNG (24x24 or 48x48 pixels recommended)
echo    - You can use online converters like: https://cloudconvert.com/svg-to-png
echo 3. Save with the exact filename shown in parentheses
echo 4. Place all files in: assets\images\skills\
echo.
echo After adding all logos, run: flutter pub get
echo.
pause
