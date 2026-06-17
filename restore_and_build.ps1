# Utility script to restore packages and rebuild solution cleanly.
param()
Write-Host "Removing PrecompiledWeb folders..."
Get-ChildItem -Path . -Recurse -Directory -Filter PrecompiledWeb -ErrorAction SilentlyContinue | ForEach-Object { Remove-Item -Recurse -Force $_.FullName }
Write-Host "Clearing NuGet packages folder under Precompiled outputs..."
if(Test-Path .\packages){ Write-Host "Local packages folder exists; leaving as-is." }
Write-Host "Restoring NuGet packages..."
if(-not (Test-Path .\nuget.exe)){
    Write-Host "Downloading nuget.exe..."
    Invoke-WebRequest "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe" -OutFile .\nuget.exe
}
.\nuget.exe restore .\PropertyForRentEdit.sln
Write-Host "Building solution with MSBuild..."
& "$env:VSINSTALLDIR\MSBuild\Current\Bin\MSBuild.exe" "PropertyForRentEdit.sln" /t:Rebuild /p:Configuration=Debug
