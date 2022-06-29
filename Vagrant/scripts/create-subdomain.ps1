# takes in a parameter ip address as a string
param ([String] $ip)

# get first 3 octets of ip address
$subnet = $ip -replace "\.\d+$", ""

# domain name
$domain = "adapt.com"

  Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Installing RSAT tools"
  # import server manager
  Import-Module ServerManager
  # add new remote server admin tools features > active directory powershell > active directory admin center  
  Add-WindowsFeature RSAT-AD-PowerShell, RSAT-AD-AdminCenter

  Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Creating subdomain controller..."

  # get computer name
  $computerName = $env:COMPUTERNAME
  # get subdomain name
  if ($computerName -like "private") {
    $subdomain = "private"
  }
  else {
    $subdomain = "testing"
  }
  # ---------------------------------------------------------------------------------------------------------
  # path locating the user
  $user = "adapt.com\vagrant"
  # password for user
  $pass = ConvertTo-SecureString "vagrant" -AsPlainText -Force
  # set user and password into a new PSCredential object
  $DomainCred = New-Object System.Management.Automation.PSCredential $user, $pass

  # plain password
  $PlainPassword = "vagrant" # "P@ssw0rd"
  # convert plain password to secure password
  $SecurePassword = $PlainPassword | ConvertTo-SecureString -AsPlainText -Force

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
    -ParentDomainName $domain`
    -NewDomainName $subdomain `
    -InstallDns:$true `
    -NoRebootOnCompletion:$true `
    -Credential $DomainCred `
    -Force:$true
  # ---------------------------------------------------------------------------------------------------------

  # new dns servers
  $newDNSServers = "127.0.0.1", "8.8.8.8", "4.4.4.4"
  
  # get the adapter information where the ip address matches the first 3 octets
  $adapters = Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object { $_.IPAddress -And ($_.IPAddress).StartsWith($subnet) }
  # if there is adapters
  if ($adapters) {
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Setting DNS"
    # Don't do this in Azure. If the network adatper description contains "Hyper-V", this won't apply changes.
    # if the adapters does not contain "hyper-V", then the dns servers will be set as the value in the variable
    $adapters | ForEach-Object { if (!($_.Description).Contains("Hyper-V")) { $_.SetDNSServerSearchOrder($newDNSServers) } }
  }

  Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Setting timezone to SG time"
  # set timezone to SGT
  c:\windows\system32\tzutil.exe /s "Singapore Standard Time"

  # excludes nat interface from dns (no idea why, does not work too but put just in case)--------------------------------------------
  Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Excluding NAT interface from DNS"
  # get the network interface with ip enabled and have an ip of 172.25._._
  $nics = Get-WmiObject "Win32_NetworkAdapterConfiguration where IPEnabled='TRUE'" | ? { $_.IPAddress[0] -ilike "172.25.*" }
  # get the ip address
  $dnslistenip = $nics.IPAddress
  $dnslistenip
  # set ip that listens to dns request to the ip address
  dnscmd /ResetListenAddresses  $dnslistenip

  # get the network interface with ip enabled and ip of 10._._._
  $nics = Get-WmiObject "Win32_NetworkAdapterConfiguration where IPEnabled='TRUE'" | ? { $_.IPAddress[0] -ilike "10.*" }
  # for each network interface
  foreach ($nic in $nics) {
    # disable domain dns registration (thingy that allows the user to use his own dns)
    $nic.DomainDNSRegistrationEnabled = $false
    # disable dynamic dns registration and have null as a result
    $nic.SetDynamicDNSRegistration($false) | Out-Null
  }

  # get resource records
  $RRs = Get-DnsServerResourceRecord -ZoneName $domain -type 1 -Name "@"
  # for each resource record
  foreach ($RR in $RRs) {
    # if the resource record has an ip of 10._._._
    if ( (Select-Object  -InputObject $RR HostName, RecordType -ExpandProperty RecordData).IPv4Address -ilike "10.*") {
      # remove said resource record
      Remove-DnsServerResourceRecord -ZoneName $domain -RRType A -Name "@" -RecordData $RR.RecordData.IPv4Address -Confirm
    }
  }
  # restart dns service
  Restart-Service DNS