<<<<<<< HEAD
# Utility script to restore packages and rebuild solution cleanly.
param()
Write-Host "Removing PrecompiledWeb folders..."
Get-ChildItem -Path . -Recurse -Directory -Filter PrecompiledWeb -ErrorAction SilentlyContinue | ForEach-Object { Remove-Item -Recurse -Force $_.FullName }
=======
# Utility script to restore packages and rebuild solution cleanly.
param()
Write-Host "Removing PrecompiledWeb folders..."
Get-ChildItem -Path . -Recurse -Directory -Filter PrecompiledWeb -ErrorAction SilentlyContinue | ForEach-Object { Remove-Item -Recurse -Force $_.FullName }
>>>>>>> 204766cb2f729d0403a4ec624e93ac6c5522c789
Write-Host "Clearing NuGet packages folder under Precompiled outputs..."
if(Test-Path .\packages){ Write-Host "Local packages folder exists; leaving as-is." }
Write-Host "Restoring NuGet packages..."
if(-not (Test-Path .\nuget.exe)){
    Write-Host "Downloading nuget.exe..."
    Invoke-WebRequest "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe" -OutFile .\nuget.exe
}
.\nuget.exe restore .\PropertyForRentEdit.sln
<<<<<<< HEAD
Write-Host "Building solution with MSBuild..."
=======
Write-Host "Building solution with MSBuild..."
>>>>>>> 204766cb2f729d0403a4ec624e93ac6c5522c789
& "$env:VSINSTALLDIR\MSBuild\Current\Bin\MSBuild.exe" "PropertyForRentEdit.sln" /t:Rebuild /p:Configuration=Debug
