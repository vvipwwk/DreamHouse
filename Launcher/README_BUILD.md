# Building DreamhouseLauncher.exe

## Requirements
- Windows 10/11
- .NET SDK 4.8 or higher  
  Download: https://dotnet.microsoft.com/en-us/download/dotnet-framework/net48
- IIS Express (end users need this too)  
  Download: https://www.microsoft.com/en-us/download/details.aspx?id=48264

## Build Steps (one-time, done by developer)

Open PowerShell in the `Launcher/` folder and run:

```powershell
dotnet build -c Release
```

The compiled exe will be at:
```
Launcher\bin\Release\net48\DreamhouseLauncher.exe
```

## Deployment for End Users

1. Copy `DreamhouseLauncher.exe` into the **project root folder**
   (same level as `Web.config`, `Default.aspx`, etc.)
2. Make sure `IIS Express` is installed on the end user's PC
3. User double-clicks `DreamhouseLauncher.exe` — that's it!

## What the Launcher Does
- Starts IIS Express pointing at the project root
- Auto-opens the browser to http://localhost:58457
- Shows a tray icon — right-click to open, show, or exit
- Closing the window minimizes to tray (server keeps running)
- "Stop Server" button shuts down IIS Express cleanly
