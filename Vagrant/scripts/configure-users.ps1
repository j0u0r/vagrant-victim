function Createusers {
    param (
        $users, $dcname
    )
    foreach ($user in $users) {
        # user -> (username,name,password,OU,dc name,admin?)
        $username = $user[0]
        Start-Sleep 5
        if (!(Get-ADUser -Filter "Name -like '*$username*'")) {
            Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Creating $username user"
            Start-Sleep 5
            New-ADUser -Server $dcname -Name $user[0] -Description $user[1] -Accountpassword (ConvertTo-SecureString $user[2] -AsPlainText -Force) -Enabled $true -ChangePasswordAtLogon $false -Path $user[3]
            Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Created $username user"
            if ($user[4] -eq 1) {
                Start-Sleep 5
                $grpstr = Get-ADPrincipalGroupMembership "$username" | Select-Object name | out-string
                if ($grpstr -like "*Domain Admins*") {
                    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) $username user already added to Domain Admins group"
                }
                else {
                    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Adding $username user to Domain Admins group"
                    Start-Sleep 5
                    Add-ADGroupMember -Identity "Domain Admins" -Members $username
                    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Added $username user to Domain Admins group"
                }
            }
        }
        else {
            Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) User $username already created"
        }
    }
}

if ($env:COMPUTERNAME -imatch 'dc-adapt-com') {
    Start-Sleep 5
    $vagrantgrps = Get-ADPrincipalGroupMembership vagrant | Select-Object name | out-string
    if ($vagrantgrps -like "*Enterprise Admins*") {
        Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) vagrant user already added to Enterprise Admins group"
    }
    else {
        Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Adding vagrant user to Enterprise Admins group"
        Start-Sleep 5
        Add-ADGroupMember -Identity "Enterprise Admins" -Members vagrant
        Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Added vagrant user to Enterprise Admins group"
    }
    
    Start-Sleep 5
    $vagrantou = get-aduser -identity vagrant | Select-Object distinguishedname | out-string
    if ($vagrantou -like "*OU=SysAdmin,DC=adapt,DC=com*") {
        Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) vagrant user already in SysAdmin OU"
    }
    else {
        Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Adding vagrant user to SysAdmin OU"
        Start-Sleep 5
        Get-ADUser -Identity vagrant | Move-ADObject -TargetPath "OU=SysAdmin,DC=adapt,DC=com"
        Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Added vagrant user to SysAdmin OU"
    }

    $users = @(
        ("jamesbond", "James Bond", "P@sswordjb", "OU=Individual,DC=adapt,DC=com", 0), 
        ("masteryoda", "Master Yoda", "P@sswordmy", "OU=Individual,DC=adapt,DC=com", 0),
        ("corporate", "Corporate", "P@sswordc", "OU=Corporate,DC=adapt,DC=com", 0)
    )
    Createusers $users "dc-adapt-com"
}
ElseIf ($env:COMPUTERNAME -imatch 'sdc-private') {
    $users = @(
        ("admin", "Admin", "P@ssworda", "OU=SysAdmin,DC=private,DC=adapt,DC=com", 1),
        ("it", "IT Manager", "P@sswordi", "OU=IT,DC=private,DC=adapt,DC=com", 0),
        ("hr", "HR Manager", "P@sswordh", "OU=HR,DC=private,DC=adapt,DC=com", 0),
        ("sales", "Sales Manager", "P@sswords", "OU=Sales,DC=private,DC=adapt,DC=com", 0)
    )
    Createusers $users "sdc-private"
}
ElseIf ($env:COMPUTERNAME -imatch 'sdc-testing') {
    $users = @(
        ("testadmin", "test Admin", "P@sswordta", "OU=SysAdmin,DC=testing,DC=adapt,DC=com", 1),
        ("testit", "test IT Manager", "P@sswordti", "OU=IT,DC=testing,DC=adapt,DC=com", 0),
        ("testhr", "test HR Manager", "P@sswordth", "OU=HR,DC=testing,DC=adapt,DC=com", 0),
        ("testsales", "test Sales Manager", "P@sswordts", "OU=Sales,DC=testing,DC=adapt,DC=com", 0)
    )
    Createusers $users "sdc-testing"
}
Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Completed user configuration."
