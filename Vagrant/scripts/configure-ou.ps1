# Hardcoding DC hostname in hosts file to sidestep any DNS issues
function CreateOUs {
    param (
        $OUs, $dcname
    )

    foreach ($OU in $OUs) {
        # OU -> (name, distinguished name)
        $counter = 0
        $OU_created = 0
        $name = $OU[0]
        while ($OU_created -ne 1) {
            Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Creating $name OU..."
            try {
                Get-ADOrganizationalUnit -Identity $OU[1] | Out-Null
                Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) $name OU already exists. Moving On."
                $OU_created = 1
            }
            catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] {
                New-ADOrganizationalUnit -Name $OU[0] -Server $dcname
                Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Created $name OU."
                $OU_created = 1
            }
            catch [Microsoft.ActiveDirectory.Management.ADServerDownException] {
                if ($counter -ne 7) {
                    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Unable to reach Active Directory. Sleeping for 5 and trying again..."
                    Start-Sleep 5
                    $counter += 1
                }
                else {
                    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Unable to reach Active Directory. Too many retries, time to stop."
                    break
                }
            }
            catch {
                if ($counter -ne 7) {
                    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Something went wrong attempting to reach AD or create the OU, sleeping for 5 and retrying..."
                    Start-Sleep 5
                    $counter += 1
                }
                else {
                    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Something went wrong attempting to reach AD or create the OU. Too many retries, time to stop."
                    break
                }
            }
        }
    }
}

If ($env:COMPUTERNAME -imatch 'dc-adapt-com') {
    Add-Content "c:\windows\system32\drivers\etc\hosts" "        192.168.56.124    dc-adapt-com.adapt.com"
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Creating OUs on adapt.com..."
    $OUs = @(
        ("Individual", "OU=Individual,DC=adapt,DC=com"),
        ("Corporate", "OU=Corporate,DC=adapt,DC=com"),
        ("SysAdmin", "OU=SysAdmin,DC=adapt,DC=com"),
        ("Workstations", "OU=Workstations,DC=adapt,DC=com")
    )
    CreateOUs $OUs 'dc-adapt-com'
}
ElseIf ($env:COMPUTERNAME -imatch 'sdc-private') {
    Add-Content "c:\windows\system32\drivers\etc\hosts" "        192.168.56.125    sdc-private.private.adapt.com"
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Creating OUs on private.adapt.com..."
    $OUs = @(
        ("IT", "OU=IT,DC=private,DC=adapt,DC=com"),
        ("HR", "OU=HR,DC=private,DC=adapt,DC=com"),
        ("Sales", "OU=Sales,DC=private,DC=adapt,DC=com"),
        ("SysAdmin", "OU=SysAdmin,DC=private,DC=adapt,DC=com"),
        ("Workstations", "OU=Workstations,DC=private,DC=adapt,DC=com")
    )
    CreateOUs $OUs 'sdc-private'
}
ElseIf ($env:COMPUTERNAME -imatch 'sdc-testing') {
    Add-Content "c:\windows\system32\drivers\etc\hosts" "        192.168.56.126    sdc-testing.testing.adapt.com"
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Creating OUs on testing.adapt.com..."
    $OUs = @(
        ("IT", "OU=IT,DC=testing,DC=adapt,DC=com"),
        ("HR", "OU=HR,DC=testing,DC=adapt,DC=com"),
        ("Sales", "OU=Sales,DC=testing,DC=adapt,DC=com"),
        ("SysAdmin", "OU=SysAdmin,DC=testing,DC=adapt,DC=com"),
        ("Workstations", "OU=Workstations,DC=testing,Dc=adapt,DC=com")
    )
    CreateOUs $OUs 'sdc-testing'
}