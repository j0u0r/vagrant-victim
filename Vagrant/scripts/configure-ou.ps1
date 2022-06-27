# Hardcoding DC hostname in hosts file to sidestep any DNS issues
Add-Content "c:\windows\system32\drivers\etc\hosts" "        192.168.56.124    dc-adapt-com.adapt.com"

If ($env:COMPUTERNAME -imatch 'dc-adapt-com') {
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Creating OUs on adapt.com..."
    # Create the individual OU if it doesn't exist
    $individual_ou_created = 0
    while ($individual_ou_created -ne 1) {
        Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Creating Individual OU..."
        try {
            Get-ADOrganizationalUnit -Identity 'OU=Individual,DC=adapt,DC=com' | Out-Null
            Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Individual OU already exists. Moving On."
            $individual_ou_created = 1
        }
        catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] {
            New-ADOrganizationalUnit -Name "Individual" -Server "dc-adapt-com.adapt.com"
            Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Created Individual OU."
            $individual_ou_created = 1
        }
        catch [Microsoft.ActiveDirectory.Management.ADServerDownException] {
            Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Unable to reach Active Directory. Sleeping for 5 and trying again..."
            Start-Sleep 5
        }
        catch {
            Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Something went wrong attempting to reach AD or create the OU."
        }
    }
    # Create the corporate OU if it doesn't exist
    $corporate_ou_created = 0
    while ($corporate_ou_created -ne 1) {
        Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Creating Corporate OU..."
        try {
            Get-ADOrganizationalUnit -Identity 'OU=Corporate,DC=adapt,DC=com' | Out-Null
            Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Corporate OU already exists. Moving On."
            $corporate_ou_created = 1
        }
        catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] {
            New-ADOrganizationalUnit -Name "Corporate" -Server "dc-adapt-com.adapt.com"
            Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Created Corporate OU."
            $corporate_ou_created = 1
        }
        catch [Microsoft.ActiveDirectory.Management.ADServerDownException] {
            Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Unable to reach Active Directory. Sleeping for 5 and trying again..."
            Start-Sleep 5
        }
        catch {
            Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Something went wrong attempting to reach AD or create the OU."
        }
    }
    # Create the sysadmin OU if it doesn't exist
    $sysadmin_ou_created = 0
    while ($sysadmin_ou_created -ne 1) {
        Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Creating SysAdmin OU..."
        try {
            Get-ADOrganizationalUnit -Identity 'OU=SysAdmin,DC=adapt,DC=com' | Out-Null
            Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) SysAdmin OU already exists. Moving On."
            $sysadmin_ou_created = 1
        }
        catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] {
            New-ADOrganizationalUnit -Name "SysAdmin" -Server "dc-adapt-com.adapt.com"
            Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Created SysAdmin OU."
            $sysadmin_ou_created = 1
        }
        catch [Microsoft.ActiveDirectory.Management.ADServerDownException] {
            Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Unable to reach Active Directory. Sleeping for 5 and trying again..."
            Start-Sleep 5
        }
        catch {
            Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Something went wrong attempting to reach AD or create the OU."
        }
    }
}
ElseIf ($env:COMPUTERNAME -imatch 'sdc-private') {
    # Create the IT OU if it doesn't exist
    $IT_ou_created = 0
    while ($IT_ou_created -ne 1) {
        Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Creating IT OU..."
        try {
            Get-ADOrganizationalUnit -Identity 'OU=IT,DC=private,DC=adapt,DC=com' | Out-Null
            Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) IT OU already exists. Moving On."
            $IT_ou_created = 1
        }
        catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] {
            New-ADOrganizationalUnit -Name "IT" -Server "sdc-private.private.adapt.com"
            Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Created IT OU."
            $IT_ou_created = 1
        }
        catch [Microsoft.ActiveDirectory.Management.ADServerDownException] {
            Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Unable to reach Active Directory. Sleeping for 5 and trying again..."
            Start-Sleep 5
        }
        catch {
            Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Something went wrong attempting to reach AD or create the OU."
        }
    }
    # Create the HR OU if it doesn't exist
    $HR_ou_created = 0
    while ($HR_ou_created -ne 1) {
        Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Creating HR OU..."
        try {
            Get-ADOrganizationalUnit -Identity 'OU=HR,DC=private,DC=adapt,DC=com' | Out-Null
            Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) HR OU already exists. Moving On."
            $HR_ou_created = 1
        }
        catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] {
            New-ADOrganizationalUnit -Name "HR" -Server "sdc-private.private.adapt.com"
            Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Created HR OU."
            $HR_ou_created = 1
        }
        catch [Microsoft.ActiveDirectory.Management.ADServerDownException] {
            Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Unable to reach Active Directory. Sleeping for 5 and trying again..."
            Start-Sleep 5
        }
        catch {
            Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Something went wrong attempting to reach AD or create the OU."
        }
    }
    # Create the Sales OU if it doesn't exist
    $Sales_ou_created = 0
    while ($Sales_ou_created -ne 1) {
        Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Creating Sales OU..."
        try {
            Get-ADOrganizationalUnit -Identity 'OU=Sales,DC=private,DC=adapt,DC=com' | Out-Null
            Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Sales OU already exists. Moving On."
            $Sales_ou_created = 1
        }
        catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] {
            New-ADOrganizationalUnit -Name "Sales" -Server "sdc-private.private.adapt.com"
            Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Created Sales OU."
            $Sales_ou_created = 1
        }
        catch [Microsoft.ActiveDirectory.Management.ADServerDownException] {
            Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Unable to reach Active Directory. Sleeping for 5 and trying again..."
            Start-Sleep 5
        }
        catch {
            Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Something went wrong attempting to reach AD or create the OU."
        }
        # Create the SysAdmin OU if it doesn't exist
        $SysAdmin_ou_created = 0
        while ($SysAdmin_ou_created -ne 1) {
            Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Creating SysAdmin OU..."
            try {
                Get-ADOrganizationalUnit -Identity 'OU=SysAdmin,DC=private,DC=adapt,DC=com' | Out-Null
                Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) SysAdmin OU already exists. Moving On."
                $SysAdmin_ou_created = 1
            }
            catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] {
                New-ADOrganizationalUnit -Name "SysAdmin" -Server "sdc-private.private.adapt.com"
                Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Created SysAdmin OU."
                $SysAdmin_ou_created = 1
            }
            catch [Microsoft.ActiveDirectory.Management.ADServerDownException] {
                Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Unable to reach Active Directory. Sleeping for 5 and trying again..."
                Start-Sleep 5
            }
            catch {
                Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Something went wrong attempting to reach AD or create the OU."
            }
        }
    }
}
ElseIf ($env:COMPUTERNAME -imatch 'sdc-testing') {
    # Create the Sales OU if it doesn't exist
    $Sales_ou_created = 0
    while ($Sales_ou_created -ne 1) {
        Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Creating Sales OU..."
        try {
            Get-ADOrganizationalUnit -Identity 'OU=Sales,DC=testing,DC=adapt,DC=com' | Out-Null
            Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Sales OU already exists. Moving On."
            $Sales_ou_created = 1
        }
        catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] {
            New-ADOrganizationalUnit -Name "Sales" -Server "sdc-testing.testing.adapt.com"
            Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Created Sales OU."
            $Sales_ou_created = 1
        }
        catch [Microsoft.ActiveDirectory.Management.ADServerDownException] {
            Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Unable to reach Active Directory. Sleeping for 5 and trying again..."
            Start-Sleep 5
        }
        catch {
            Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Something went wrong attempting to reach AD or create the OU."
        }
    }
    # Create the HR OU if it doesn't exist
    $HR_ou_created = 0
    while ($HR_ou_created -ne 1) {
        Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Creating HR OU..."
        try {
            Get-ADOrganizationalUnit -Identity 'OU=HR,DC=testing,DC=adapt,DC=com' | Out-Null
            Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) HR OU already exists. Moving On."
            $HR_ou_created = 1
        }
        catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] {
            New-ADOrganizationalUnit -Name "HR" -Server "sdc-testing.testing.adapt.com"
            Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Created HR OU."
            $HR_ou_created = 1
        }
        catch [Microsoft.ActiveDirectory.Management.ADServerDownException] {
            Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Unable to reach Active Directory. Sleeping for 5 and trying again..."
            Start-Sleep 5
        }
        catch {
            Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Something went wrong attempting to reach AD or create the OU."
        }
    }
    # Create the IT OU if it doesn't exist
    $IT_ou_created = 0
    while ($IT_ou_created -ne 1) {
        Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Creating IT OU..."
        try {
            Get-ADOrganizationalUnit -Identity 'OU=IT,DC=testing,DC=adapt,DC=com' | Out-Null
            Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) IT OU already exists. Moving On."
            $IT_ou_created = 1
        }
        catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] {
            New-ADOrganizationalUnit -Name "IT" -Server "sdc-testing.testing.adapt.com"
            Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Created IT OU."
            $IT_ou_created = 1
        }
        catch [Microsoft.ActiveDirectory.Management.ADServerDownException] {
            Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Unable to reach Active Directory. Sleeping for 5 and trying again..."
            Start-Sleep 5
        }
        catch {
            Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Something went wrong attempting to reach AD or create the OU."
        }
    }
    # Create the Admin OU if it doesn't exist
    $Admin_ou_created = 0
    while ($Admin_ou_created -ne 1) {
        Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Creating Admin OU..."
        try {
            Get-ADOrganizationalUnit -Identity 'OU=Admin,DC=testing,DC=adapt,DC=com' | Out-Null
            Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Admin OU already exists. Moving On."
            $Admin_ou_created = 1
        }
        catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] {
            New-ADOrganizationalUnit -Name "Admin" -Server "sdc-testing.testing.adapt.com"
            Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Created Admin OU."
            $Admin_ou_created = 1
        }
        catch [Microsoft.ActiveDirectory.Management.ADServerDownException] {
            Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Unable to reach Active Directory. Sleeping for 5 and trying again..."
            Start-Sleep 5
        }
        catch {
            Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Something went wrong attempting to reach AD or create the OU."
        }
    }
}