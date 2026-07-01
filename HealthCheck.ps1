# SCCM Client Health Check
# Author: Sharukh Ahmed

Write-Host "======================================="
Write-Host " SCCM Client Health Check"
Write-Host "======================================="

# Check SCCM Client Service
Write-Host "`n[1] SCCM Client Service"
$service = Get-Service -Name CcmExec -ErrorAction SilentlyContinue

if ($service) {
    $service | Select-Object Name, Status
} else {
    Write-Host "SCCM Client is not installed."
}

# Check Client Version
Write-Host "`n[2] SCCM Client Version"
try {
    Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client" |
        Select-Object ProductVersion
}
catch {
    Write-Host "Unable to retrieve client version."
}

# Check Assigned Site
Write-Host "`n[3] Assigned Site"

try {
    Get-CimInstance -Namespace root\ccm -ClassName SMS_Client |
        Select-Object AssignedSiteCode, CurrentManagementPoint
}
catch {
    Write-Host "Unable to retrieve site information."
}

# Check Cache Configuration
Write-Host "`n[4] SCCM Cache"

try {
    Get-CimInstance -Namespace root\ccm\SoftMgmtAgent -ClassName CacheConfig |
        Select-Object Location, Size
}
catch {
    Write-Host "Unable to retrieve cache configuration."
}

Write-Host ""
Write-Host "Health Check Completed Successfully."
