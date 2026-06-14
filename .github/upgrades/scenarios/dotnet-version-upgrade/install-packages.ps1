[xml]$xml = Get-Content "packages.config"
foreach ($pkg in $xml.packages.package) {
	$id = $pkg.id
	$version = $pkg.version
	Write-Output "Installing $id $version"
	& .\nuget.exe install $id -Version $version -OutputDirectory packages -NonInteractive -ErrorAction Stop
}
Write-Output 'All packages installed'
