$packagesConfig = "packages.config"
if (-Not (Test-Path $packagesConfig)) { Write-Error "packages.config not found"; exit 1 }
[xml]$xml = Get-Content $packagesConfig
$packages = $xml.packages.package | ForEach-Object { $_.id }
$results = @()
foreach ($p in $packages) {
	$pTrim = $p.Trim()
	$pLower = $pTrim.ToLower()
	$url = "https://api.nuget.org/v3-flatcontainer/$pLower/index.json"
	try {
		$resp = Invoke-RestMethod -Uri $url -UseBasicParsing -ErrorAction Stop
		$latest = $resp.versions[-1]
	} catch {
		$latest = '(not found)'
	}
	$results += [PSCustomObject]@{ Package = $pTrim; Latest = $latest }
}
$outPath = ".github/upgrades/scenarios/dotnet-version-upgrade/nuget-latest.json"
$results | ConvertTo-Json -Depth 4 | Out-File -FilePath $outPath -Encoding utf8
Write-Output "Wrote $outPath"
