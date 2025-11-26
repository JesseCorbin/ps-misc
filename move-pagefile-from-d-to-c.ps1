# Disable automatic pagefile management
$cs = Get-CimInstance -ClassName Win32_ComputerSystem
if ($cs.AutomaticManagedPagefile) {
    $cs.AutomaticManagedPagefile = $false
    Set-CimInstance -InputObject $cs | Out-Null
}

# Check for a pagefile on D:
$dPage = Get-CimInstance -ClassName Win32_PageFileSetting |
         Where-Object { $_.Name -like 'D:\pagefile.sys' }

if ($dPage) {
    # Remove pagefile on D:
    $dPage | Remove-CimInstance

    # Optional: also remove any existing explicit C: config
    Get-CimInstance -ClassName Win32_PageFileSetting |
        Where-Object { $_.Name -like 'C:\pagefile.sys' } |
        Remove-CimInstance -ErrorAction SilentlyContinue

    # Create system‑managed pagefile on C:
    New-CimInstance -ClassName Win32_PageFileSetting -Property @{
        Name        = 'C:\pagefile.sys'
        InitialSize = 0    # 0,0 = system‑managed size
        MaximumSize = 0
    } | Out-Null
}

Write-Host "Pagefile settings updated. A reboot is required for changes to apply."
