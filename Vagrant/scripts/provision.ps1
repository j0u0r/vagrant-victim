param ([String] $ip)

# store profile path in ProfilePath variable
$ProfilePath = "C:\Windows\System32\WindowsPowerShell\v1.0\profile.ps1"
# get computer name from HKEY
$box = Get-ItemProperty -Path HKLM:SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName -Name "ComputerName"
# turn computer name to lowercase string
$box = $box.ComputerName.ToString().ToLower()

Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Setting timezone to SGT..."
# runs timezone utility and change timezone to SG time
c:\windows\system32\tzutil.exe /s "Singapore Standard Time"

Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Checking if Windows evaluation is expiring soon or expired..."
# runs fix-windows-expiration.ps1 from vagrant to extend windows trial
. c:\vagrant\scripts\fix-windows-expiration.ps1

# if there is no directory matching ProfilePath
If (!(Test-Path $ProfilePath)) {
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Disabling the Invoke-WebRequest download progress bar globally for speed improvements." 
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) See https://github.com/PowerShell/PowerShell/issues/2138 for more info"
    # make a new file in the variable ProfilePath's path then outputs null
    New-Item -Path $ProfilePath | Out-Null
    # if there is no result for getting the file contents and matching "SilentlyContinue" in every variable 
    If (!(Get-Content $Profilepath | % { $_ -match "SilentlyContinue" } )) {
        # add SilentlyContinue to ProgressPreference, which disables errors/warnings and continue
        Add-Content -Path $ProfilePath -Value "$ProgressPreference = 'SilentlyContinue'"
    }
}

Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Disabling IPv6 on all network adatpers..."
# get tcpip6/ipv6 info from network adapter, then disable them for each binding
Get-NetAdapterBinding -ComponentID ms_tcpip6 | ForEach-Object { Disable-NetAdapterBinding -Name $_.Name -ComponentID ms_tcpip6 }
# displays ipv6 components, which by right is already disabled (for logging on host machine. i assume)
Get-NetAdapterBinding -ComponentID ms_tcpip6 
# https://support.microsoft.com/en-gb/help/929852/guidance-for-configuring-ipv6-in-windows-for-advanced-users
# disable ipv6 via HKEY
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" /v DisabledComponents /t REG_DWORD /d 255 /f

# if the machine is not part of a domain
if ((gwmi win32_computersystem).partofdomain -eq $false) {

    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Current domain is set to 'workgroup'. Time to join the domain!"
  
    # if there is no path to bginfo.exe
    if (!(Test-Path 'c:\Program Files\sysinternals\bginfo.exe')) {
        Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Installing bginfo..."
        # runs install-bginfo.ps1 in vagrant to install bginfo AND set wallpaper
        . c:\vagrant\scripts\install-bginfo.ps1
        # Set desktop background to be "fitted" instead of "tiled"
        Set-ItemProperty 'HKCU:\Control Panel\Desktop' -Name TileWallpaper -Value '0'
        Set-ItemProperty 'HKCU:\Control Panel\Desktop' -Name WallpaperStyle -Value '6'
    }
  
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) My hostname is $env:COMPUTERNAME"
    # if computer name from the env variable matches 'adapt.com' (case insensitive)
    if ($env:COMPUTERNAME -imatch 'dc-adapt-com') {
        # runs create-domain.ps1 script from vagrant
        . c:\vagrant\scripts\create-domain.ps1 192.168.56.124
    }elseif ($env:COMPUTERNAME -like 'sdc*') {
        . c:\vagrant\scripts\create-subdomain.ps1 $ip
    }
    else {
        # if computer name isnt 'dc-adapt.com'
        # runs join-domain.ps1 script from vagrant
        . c:\vagrant\scripts\join-domain.ps1 $ip
    }
# else; meaning that the vm has a domain
} else {
    Write-Host -fore green "$('[{0:HH:mm}]' -f (Get-Date)) I am domain joined!"
    # installs bginfo if there is no path
    if (!(Test-Path 'c:\Program Files\sysinternals\bginfo.exe')) {
        Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Installing bginfo..."
        . c:\vagrant\scripts\install-bginfo.ps1
    }
}

# Stop Windows Update
Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Disabling Windows Updates and Windows Module Services"
# disable windows update auto service
Set-Service wuauserv -StartupType Disabled
# stop windows update auto service
Stop-Service wuauserv
# disable trusted installer
Set-Service TrustedInstaller -StartupType Disabled
# stop trusted installer
Stop-Service TrustedInstaller