$ErrorActionPreference = "Stop"

$iisExpress = "C:\Program Files\IIS Express\iisexpress.exe"
$iisExpressx86 = "C:\Program Files (x86)\IIS Express\iisexpress.exe"

$exeToRun = ""

if (Test-Path $iisExpress) {
    $exeToRun = $iisExpress
} elseif (Test-Path $iisExpressx86) {
    $exeToRun = $iisExpressx86
} else {
    Write-Host "IIS Express is not installed. Please install IIS Express or run the project through Visual Studio." -ForegroundColor Red
    Pause
    exit
}

$port = 58457
$sitePath = $PSScriptRoot

Write-Host "Starting Dreamhouse Property Website on http://localhost:$port" -ForegroundColor Green
Write-Host "Press Ctrl+C to stop the server." -ForegroundColor Yellow

# Launch browser
Start-Process "http://localhost:$port"

# Run IIS Express
& $exeToRun /path:"$sitePath" /port:$port /clr:v4.0
