param ([String] $ip)

Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Joining the domain..."

Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) First, set DNS to DC to join the domain..."
# new dns server (dc's ip address)
$newDNSServers = "192.168.56.124"
# get network adapters with the ip address containing "192.168.56."
$adapters = Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object { $_.IPAddress -match $ip }
# Don't do this in Azure. If the network adatper description contains "Hyper-V", this won't apply changes.
# Specify the DC as a WINS server to help with connectivity as well
# if the network adapter's description does not contain "hyper-v", set new dns to dc's ip address
$adapters | ForEach-Object { if (!($_.Description).Contains("Hyper-V")) { $_.SetDNSServerSearchOrder($newDNSServers); $_.SetWINSServer($newDNSServers, "") } }

Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Now join the domain..."
# get the host name of the machine
$hostname = $(hostname)
# path locating the user
$user = "adapt.com\vagrant"
# password for user
$pass = ConvertTo-SecureString "vagrant" -AsPlainText -Force
# set user and password into a new PSCredential object
$DomainCred = New-Object System.Management.Automation.PSCredential $user, $pass

# WINDOWS 10 joins the domain
If ($hostname -like "*win10*") {
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Adding Win10 to the domain. Sometimes this step times out. If that happens, just run 'vagrant reload win10 --provision'" #debug
    # adds windows 10 to "adapt.com" and distinguished ou name (found in properties) with credentials
    Add-Computer -DomainName "adapt.com" -credential $DomainCred -PassThru
} ElseIf ($hostname -like "*sdc*"){
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Adding dc to the domain. Sometimes this step times out. If that happens, just run 'vagrant reload win10 --provision'" #debug
    # adds sdc to "adapt.com"
    Add-Computer -DomainName "adapt.com" -credential $DomainCred -PassThru
    . c:\vagrant\scripts\create-subdomain.ps1
}
Else {
    # if fail, just add windows 10 to the domain without ou
    Add-Computer -DomainName "adapt.com" -credential $DomainCred -PassThru
}