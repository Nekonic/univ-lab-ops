$prov = (Get-AppxProvisionedPackage -Online).PackageName
Get-AppxPackage -AllUsers | Where-Object {
    -not $_.IsFramework -and -not $_.NonRemovable -and $prov -notcontains $_.PackageFullName
} | ForEach-Object {
    Write-Host "제거: $($_.Name)"
    Remove-AppxPackage -Package $_.PackageFullName -AllUsers -ErrorAction SilentlyContinue
}