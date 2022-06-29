function Createusers {
    param (
        $users, $dcname
    )
    foreach ($user in $users) {
        # user -> (username,name,password,OU,dc name,admin?)
        $username = $user[0]
        if (!(Get-ADUser -Filter "Name -like '$username'")) {
            Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Creating $username user"
            New-ADUser -Server $dcname -Name $user[0] -Description $user[1] -Accountpassword (ConvertTo-SecureString $user[2] -AsPlainText -Force) -Enabled $true -ChangePasswordAtLogon $false -Path $user[3]
            Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Created $username user"
            if ($user[4] -eq 1) {
                Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Adding $username user to Domain Admins group"
                Add-ADGroupMember -Identity "Domain Admins" -Members $username
                Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Added $username user to Domain Admins group"
            }
        }
        else {
            Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) User $username already created"
        }
    }
}

if ($env:COMPUTERNAME -imatch 'dc-adapt-com') {
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Adding vagrant user to Domain Admins group"
    Add-ADGroupMember -Identity "Domain Admins" -Members vagrant
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Added vagrant user to Domain Admins group"
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Adding vagrant user to SysAdmin OU"
    Get-ADUser -Identity vagrant | Move-ADObject -TargetPath "OU=SysAdmin,DC=adapt,DC=com"
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Added vagrant user to SysAdmin OU"

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
        ("it", "IT Manager", "P@sswordi", "OU=IT,DC=private,DC=adapt,DC=com", 0)
    )
    
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Creating HR Manager user"
    $hrmanagerpw = "P@sswordh"
    $hrmanagerspw = $hrmanagerpw | ConvertTo-SecureString -AsPlainText -Force
    New-ADUser -Server sdc-private -Name "hr" -Description "HR Manager" -Accountpassword $hrmanagerspw -Enabled $true -ChangePasswordAtLogon $false -Path "OU=HR,DC=private,DC=adapt,DC=com"
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Created HR Manager user"
    
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Creating Sales Manager user"
    $salesmanagerpw = "P@sswords"
    $salesmanagerspw = $salesmanagerpw | ConvertTo-SecureString -AsPlainText -Force
    New-ADUser -Server sdc-private -Name "sales" -Description "Sales Manager" -Accountpassword $salesmanagerspw -Enabled $true -ChangePasswordAtLogon $false -Path "OU=Sales,DC=private,DC=adapt,DC=com"
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Created Sales Manager user"
}
ElseIf ($env:COMPUTERNAME -imatch 'sdc-testing') {
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Creating Admin user"
    $testadminpw = "P@sswordta"
    $testadminspw = $testadminpw | ConvertTo-SecureString -AsPlainText -Force
    New-ADUser -Server sdc-testing -Name "testadmin" -Description "test Admin" -Accountpassword $testadminspw -Enabled $true -ChangePasswordAtLogon $false -Path "OU=SysAdmin,DC=testing,DC=adapt,DC=com"
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Created Admin user"
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Adding Admin user to Admin group"
    Add-ADGroupMember -Identity "Administrators" -Members testadmin
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Adding Admin user to Admin group"
   
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Creating IT Manager user"
    $testitpw = "P@sswordti"
    $testitspw = $testitpw | ConvertTo-SecureString -AsPlainText -Force
    New-ADUser -Server sdc-testing -Name "testit" -Description "test IT Manager" -Accountpassword $testitspw -Enabled $true -ChangePasswordAtLogon $false -Path "OU=IT,DC=testing,DC=adapt,DC=com"
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Created IT Manager user"
    
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Creating Sales Manager user"
    $testsalespw = "P@sswordts"
    $testsalesspw = $testsalespw | ConvertTo-SecureString -AsPlainText -Force
    New-ADUser -Server sdc-testing -Name "testsales" -Description "test Sales Manager" -Accountpassword $testsalesspw -Enabled $true -ChangePasswordAtLogon $false -Path "OU=Sales,DC=testing,DC=adapt,DC=com"
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Created Sales Manager user"
    
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Creating HR Manager user"
    $testhrpw = "P@sswordth"
    $testhrspw = $testhrpw | ConvertTo-SecureString -AsPlainText -Force
    New-ADUser -Server sdc-testing -Name "testhr" -Description "test HR Manager" -Accountpassword $testhrspw -Enabled $true -ChangePasswordAtLogon $false -Path "OU=HR,DC=testing,DC=adapt,DC=com"
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Created HR Manager user"
}
