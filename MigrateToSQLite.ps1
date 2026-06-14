$ErrorActionPreference = "Stop"

# 1. Ensure NuGet is available
$nugetExe = ".\nuget.exe"
if (-not (Test-Path $nugetExe)) {
    Write-Host "Downloading nuget.exe..."
    Invoke-WebRequest "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe" -OutFile $nugetExe
}

# 2. Install System.Data.SQLite.Core package
Write-Host "Installing System.Data.SQLite.Core..."
& $nugetExe install System.Data.SQLite.Core -Version 1.0.118.0 -OutputDirectory packages
# Ignoring exit code because it might just report already installed

# 3. Copy DLLs to Bin folder
$binDir = ".\Bin"
if (-not (Test-Path $binDir)) {
    New-Item -ItemType Directory -Path $binDir | Out-Null
}

$sqlitePkgDir = ".\packages\Stub.System.Data.SQLite.Core.NetFramework.1.0.118.0"
Write-Host "Copying System.Data.SQLite.dll to Bin..."
Copy-Item "$sqlitePkgDir\lib\net46\System.Data.SQLite.dll" -Destination $binDir -Force

$x86Dir = "$binDir\x86"
$x64Dir = "$binDir\x64"
if (-not (Test-Path $x86Dir)) { New-Item -ItemType Directory -Path $x86Dir | Out-Null }
if (-not (Test-Path $x64Dir)) { New-Item -ItemType Directory -Path $x64Dir | Out-Null }

Write-Host "Copying SQLite.Interop.dll to Bin\x86 and Bin\x64..."
Copy-Item "$sqlitePkgDir\build\net46\x86\SQLite.Interop.dll" -Destination $x86Dir -Force
Copy-Item "$sqlitePkgDir\build\net46\x64\SQLite.Interop.dll" -Destination $x64Dir -Force

# 4. Create App_Data folder and Database
$appDataDir = ".\App_Data"
if (-not (Test-Path $appDataDir)) {
    New-Item -ItemType Directory -Path $appDataDir | Out-Null
}

$dbPath = "$appDataDir\Dreamhouse.db"
if (Test-Path $dbPath) {
    Write-Host "Removing existing database..."
    Remove-Item $dbPath -Force
}

# Load SQLite Assembly
Add-Type -Path "$binDir\System.Data.SQLite.dll"

Write-Host "Creating SQLite database..."
[System.Data.SQLite.SQLiteConnection]::CreateFile($dbPath)

$connString = "Data Source=$dbPath;Version=3;"
$conn = New-Object System.Data.SQLite.SQLiteConnection($connString)
$conn.Open()

# 5. Create Tables
$cmd = $conn.CreateCommand()

$cmd.CommandText = @"
CREATE TABLE PrivateOwner (
    ownerNo VARCHAR(10) PRIMARY KEY
);
CREATE TABLE Staff (
    staffNo VARCHAR(10) PRIMARY KEY
);
CREATE TABLE Branch (
    branchNo VARCHAR(10) PRIMARY KEY
);
CREATE TABLE PropertyForRent (
    propertyNo VARCHAR(10) PRIMARY KEY,
    street VARCHAR(100),
    city VARCHAR(50),
    postcode VARCHAR(20),
    type VARCHAR(50),
    rooms VARCHAR(10),
    rent DECIMAL(10,2),
    ownerNo VARCHAR(10),
    staffNo VARCHAR(10),
    branchNo VARCHAR(10),
    FOREIGN KEY(ownerNo) REFERENCES PrivateOwner(ownerNo),
    FOREIGN KEY(staffNo) REFERENCES Staff(staffNo),
    FOREIGN KEY(branchNo) REFERENCES Branch(branchNo)
);
"@
$cmd.ExecuteNonQuery() | Out-Null

# 6. Seed Data
$cmd.CommandText = @"
INSERT INTO PrivateOwner (ownerNo) VALUES ('CO46'), ('CO87'), ('CO40'), ('CO93');
INSERT INTO Staff (staffNo) VALUES ('SA9'), ('SG14'), ('SG37'), ('SL41');
INSERT INTO Branch (branchNo) VALUES ('B002'), ('B003'), ('B005'), ('B007');

INSERT INTO PropertyForRent (propertyNo, street, city, postcode, type, rooms, rent, ownerNo, staffNo, branchNo) VALUES 
('PA14', '16 Holhead', 'Aberdeen', 'AB7 5SU', 'House', '6', 650.00, 'CO46', 'SA9', 'B007'),
('PG16', '5 Novar Dr', 'Glasgow', 'G12 9AX', 'Flat', '4', 450.00, 'CO93', 'SG14', 'B003'),
('PG21', '18 Dale Rd', 'Glasgow', 'G12', 'House', '5', 600.00, 'CO87', 'SG37', 'B003'),
('PG36', '2 Manor Rd', 'Glasgow', 'G32 4QX', 'Flat', '3', 375.00, 'CO93', 'SG37', 'B003'),
('PG4', '6 Lawrence St', 'Glasgow', 'G11 9QX', 'Flat', '3', 350.00, 'CO40', 'SG14', 'B003'),
('PL94', '6 Argyll St', 'London', 'NW2', 'Flat', '4', 400.00, 'CO87', 'SL41', 'B005');
"@
$cmd.ExecuteNonQuery() | Out-Null

$conn.Close()
Write-Host "Database migration and seeding completed successfully!"
