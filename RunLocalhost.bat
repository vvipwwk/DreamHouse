@echo off
set PORT=8080
set "SITE_PATH=%~dp0"
set "IIS_EXPRESS=C:\Program Files\IIS Express\iisexpress.exe"
set "IIS_EXPRESS_X86=C:\Program Files (x86)\IIS Express\iisexpress.exe"

IF EXIST "%IIS_EXPRESS%" (
    set "EXE_TO_RUN=%IIS_EXPRESS%"
    goto :RunServer
)

IF EXIST "%IIS_EXPRESS_X86%" (
    set "EXE_TO_RUN=%IIS_EXPRESS_X86%"
    goto :RunServer
)

echo =========================================================================
echo [ERROR] IIS Express is not installed on this system.
echo.
echo To run this ASP.NET application locally, you need Microsoft IIS Express.
echo I will now open the official Microsoft download page in your browser.
echo.
echo Please click "Download", install it, and then run this script again.
echo =========================================================================
pause

start https://www.microsoft.com/en-us/download/details.aspx?id=48264
exit /b

:RunServer
echo.
echo =========================================================
echo Starting Dreamhouse Property Website on http://localhost:%PORT%
echo Press Ctrl+C to stop the server.
echo =========================================================
echo.

start http://localhost:%PORT%
"%EXE_TO_RUN%" /path:"%SITE_PATH:~0,-1%" /port:%PORT%
