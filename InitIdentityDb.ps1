$ErrorActionPreference = "Stop"

$binDir = ".\Bin"
$appDataDir = ".\App_Data"
$dbPath = "$appDataDir\Dreamhouse.db"

# Load SQLite Assembly
Add-Type -Path "$binDir\System.Data.SQLite.dll"

$connString = "Data Source=$dbPath;Version=3;"
$conn = New-Object System.Data.SQLite.SQLiteConnection($connString)
$conn.Open()

$cmd = $conn.CreateCommand()

$cmd.CommandText = @"
CREATE TABLE IF NOT EXISTS [AspNetRoles] (
    [Id] NVARCHAR(128) NOT NULL PRIMARY KEY,
    [Name] NVARCHAR(256) NOT NULL
);

CREATE TABLE IF NOT EXISTS [AspNetUsers] (
    [Id] NVARCHAR(128) NOT NULL PRIMARY KEY,
    [Email] NVARCHAR(256),
    [EmailConfirmed] bit NOT NULL,
    [PasswordHash] TEXT,
    [SecurityStamp] TEXT,
    [PhoneNumber] TEXT,
    [PhoneNumberConfirmed] bit NOT NULL,
    [TwoFactorEnabled] bit NOT NULL,
    [LockoutEndDateUtc] datetime,
    [LockoutEnabled] bit NOT NULL,
    [AccessFailedCount] int NOT NULL,
    [UserName] NVARCHAR(256) NOT NULL
);

CREATE TABLE IF NOT EXISTS [AspNetUserClaims] (
    [Id] INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    [UserId] NVARCHAR(128) NOT NULL,
    [ClaimType] TEXT,
    [ClaimValue] TEXT,
    FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS [AspNetUserLogins] (
    [LoginProvider] NVARCHAR(128) NOT NULL,
    [ProviderKey] NVARCHAR(128) NOT NULL,
    [UserId] NVARCHAR(128) NOT NULL,
    PRIMARY KEY ([LoginProvider], [ProviderKey], [UserId]),
    FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS [AspNetUserRoles] (
    [UserId] NVARCHAR(128) NOT NULL,
    [RoleId] NVARCHAR(128) NOT NULL,
    PRIMARY KEY ([UserId], [RoleId]),
    FOREIGN KEY ([RoleId]) REFERENCES [AspNetRoles] ([Id]) ON DELETE CASCADE,
    FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS [Purchases] (
    [PurchaseId] INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    [PropertyNo] VARCHAR(10) NOT NULL,
    [UserId] NVARCHAR(128) NOT NULL,
    [PurchaseDate] DATETIME NOT NULL,

    [BuyerName] NVARCHAR(256),
    [BuyerEmail] NVARCHAR(256),
    [ContactNo] NVARCHAR(50),
    [BillingAddress] TEXT,
    [MonthlyRent] DECIMAL(10,2),
    [ServiceFee] DECIMAL(10,2),
    [TaxAmount] DECIMAL(10,2),
    [TotalAmount] DECIMAL(10,2),
    [PaymentMethod] NVARCHAR(50),
    [Status] NVARCHAR(50),

    FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]),
    FOREIGN KEY ([PropertyNo]) REFERENCES [PropertyForRent] ([propertyNo])
);
"@
$cmd.ExecuteNonQuery() | Out-Null

$conn.Close()
Write-Host "Identity tables created successfully in Dreamhouse.db!"
