# powershell script to test code
$newDNSServers = "192.168.56.124"
$adapters = Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object {$_.IPAddress -match "192.168.56."}
# if there is adapters
Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Setting DNS"
# Don't do this in Azure. If the network adatper description contains "Hyper-V", this won't apply changes.
# if the adapters does not contain "hyper-V", then the dns servers will be set as the value in the variable
$adapters | ForEach-Object { if (!($_.Description).Contains("Hyper-V")) { $_.SetDNSServerSearchOrder($newDNSServers) } }
$user = "adapt.com\vagrant"
$pass = ConvertTo-SecureString "vagrant" -AsPlainText -Force
$DomainCred = New-Object System.Management.Automation.PSCredential $user, $pass
$PlainPassword = "vagrant" # "P@ssw0rd"
$SecurePassword = $PlainPassword | ConvertTo-SecureString -AsPlainText -Force
Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) First, set DNS to DC to contact domain..."
# set up new subdomain----------------------------------------------------------------------------------------
Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Creating subdomain..."
# Windows Server 2016 R2
# install active directory domain services
Install-WindowsFeature AD-domain-services
# import active directory domain services deployment
Import-Module ADDSDeployment
# install active directory domain services forest
Install-ADDSDomain `
  -SafeModeAdministratorPassword $SecurePassword `
  -CreateDnsDelegation:$false `
  -DomainMode "7" `
  -ParentDomainName adapt.com `
  -NewDomainName private `
  -InstallDns:$true `
  -NoRebootOnCompletion:$true `
  -Credential $DomainCred `
  -Force:$true