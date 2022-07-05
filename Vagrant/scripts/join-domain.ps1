param ([String] $ip)

Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Joining the domain..."

# get the host name of the machine
$hostname = $(hostname)

Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) First, set DNS to DC to join the domain..."
if ($hostname -like "*private") {
    $newDNSServers = "192.168.56.125"
    # path locating the user
    $user = "private.adapt.com\vagrant"
    # password for user
    $pass = ConvertTo-SecureString "vagrant" -AsPlainText -Force
    # set user and password into a new PSCredential object
    $DomainCred = New-Object System.Management.Automation.PSCredential $user, $pass
}
elseif ($hostname -like "*testing") {
    $newDNSServers = "192.168.56.126"
    # path locating the user
    $user = "testing.adapt.com\vagrant"
    # password for user
    $pass = ConvertTo-SecureString "vagrant" -AsPlainText -Force
    # set user and password into a new PSCredential object
    $DomainCred = New-Object System.Management.Automation.PSCredential $user, $pass
}
else {
    $newDNSServers = "192.168.56.124"
    # path locating the user
    $user = "adapt.com\vagrant"
    # password for user
    $pass = ConvertTo-SecureString "vagrant" -AsPlainText -Force
    # set user and password into a new PSCredential object
    $DomainCred = New-Object System.Management.Automation.PSCredential $user, $pass
}

# get network adapters with the ip address containing ip address
$adapters = Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object { $_.IPAddress -match $ip }
# Don't do this in Azure. If the network adatper description contains "Hyper-V", this won't apply changes.
# Specify the DC as a WINS server to help with connectivity as well
# if the network adapter's description does not contain "hyper-v", set new dns to dc's ip address
$adapters | ForEach-Object { if (!($_.Description).Contains("Hyper-V")) { $_.SetDNSServerSearchOrder($newDNSServers); $_.SetWINSServer($newDNSServers, "") } }

Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Now join the domain..."
# WINDOWS 10 joins the domain
If ($hostname -like "*win10*") {
    if ($hostname -like "*adapt-com") {
        Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Adding Win10 to adapt.com domain. Sometimes this step times out. If that happens, just run 'vagrant reload win10 --provision'" #debug
        Add-Computer -DomainName "adapt.com" -credential $DomainCred -OUPath "OU=Workstations,DC=adapt,DC=com"
    }
    elseif ($hostname -like "*private") {
        Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Adding Win10 to private.adapt.com subdomain. Sometimes this step times out. If that happens, just run 'vagrant reload win10 --provision'" #debug
        Add-Computer -DomainName "private.adapt.com" -credential $DomainCred -OUPath "OU=Workstations,DC=private,DC=adapt,DC=com"
    }
    elseif ($hostname -like "*testing") {
        Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Adding Win10 to testing.adapt.com subdomain. Sometimes this step times out. If that happens, just run 'vagrant reload win10 --provision'" #debug
        Add-Computer -DomainName "testing.adapt.com" -credential $DomainCred -OUPath "OU=Workstations,DC=testing,DC=adapt,DC=com"
    }
    else {
        Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Domain not specified, adding Win10 to adapt.com domain. Sometimes this step times out. If that happens, just run 'vagrant reload win10 --provision'" #debug
        Add-Computer -DomainName "adapt.com" -credential $DomainCred -OUPath "OU=Workstations,DC=adapt,DC=com"
    }
}
Else {
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Machine type not specified, adding machine to adapt.com domain..." #debug
    Add-Computer -DomainName "adapt.com" -credential $DomainCred -PassThru
}