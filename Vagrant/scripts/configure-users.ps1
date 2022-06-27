if ($env:COMPUTERNAME -imatch 'dc-adapt-com') {
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Adding vagrant user to Domain Admins group"
    Add-ADGroupMember -Identity "Domain Admins" -Members vagrant
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Added vagrant user to Domain Admins group"
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Adding vagrant user to SysAdmin OU"
    Get-ADUser -Identity vagrant | Move-ADObject -TargetPath "OU=SysAdmin,DC=adapt,DC=com"
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Added vagrant user to SysAdmin OU"

    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Creating James Bond user"
    $jamesbondpw= "P@sswordjb"
    $jamesbondspw = $jamesbondpw | ConvertTo-SecureString -AsPlainText -Force
    New-ADUser -Server dc-adapt-com -Name "jamesbond" -Description "James Bond" -Accountpassword $jamesbondspw -Enabled $true -ChangePasswordAtLogon $false -Path "OU=Individual,DC=adapt,DC=com"
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Created James Bond user"

    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Creating Master Yoda user"
    $masteryodapw= "P@sswordmy"
    $masteryodaspw = $masteryodapw | ConvertTo-SecureString -AsPlainText -Force
    New-ADUser -Server dc-adapt-com -Name "masteryoda" -Description "Master Yoda" -Accountpassword $masteryodaspw -Enabled $true -ChangePasswordAtLogon $false -Path "OU=Individual,DC=adapt,DC=com"
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Created Master Yoda user"

    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Creating Corporate user"
    $corporatepw= "P@sswordc"
    $corporatespw = $corporatepw | ConvertTo-SecureString -AsPlainText -Force
    New-ADUser -Server dc-adapt-com -Name "corporate" -Description "Corporate" -Accountpassword $corporatespw -Enabled $true -ChangePasswordAtLogon $false -Path "OU=Corporate,DC=adapt,DC=com"
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Created Corporate user"
}
ElseIf ($env:COMPUTERNAME -imatch 'sdc-private') {
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Creating Admin user"
    $adminpw= "P@ssworda"
    $adminspw = $adminpw | ConvertTo-SecureString -AsPlainText -Force
    New-ADUser -Server sdc-private -Name "admin" -Description "Admin" -Accountpassword $adminspw -Enabled $true -ChangePasswordAtLogon $false -Path "OU=SysAdmin,DC=private,DC=adapt,DC=com"
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Created Admin user"
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Adding Admin user to Admin group"
    Add-ADGroupMember -Identity "Administrators" -Members admin
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Added Admin user to Admin group"

    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Creating IT Manager user"
    $itmanagerpw= "P@sswordi"
    $itmanagerspw = $itmanagerpw | ConvertTo-SecureString -AsPlainText -Force
    New-ADUser -Server sdc-private -Name "it" -Description "IT Manager" -Accountpassword $itmanagerspw -Enabled $true -ChangePasswordAtLogon $false -Path "OU=IT,DC=private,DC=adapt,DC=com"
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Created IT Manager user"
    
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Creating HR Manager user"
    $hrmanagerpw= "P@sswordh"
    $hrmanagerspw = $hrmanagerpw | ConvertTo-SecureString -AsPlainText -Force
    New-ADUser -Server sdc-private -Name "hr" -Description "HR Manager" -Accountpassword $hrmanagerspw -Enabled $true -ChangePasswordAtLogon $false -Path "OU=HR,DC=private,DC=adapt,DC=com"
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Created HR Manager user"
    
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Creating Sales Manager user"
    $salesmanagerpw= "P@sswords"
    $salesmanagerspw = $salesmanagerpw | ConvertTo-SecureString -AsPlainText -Force
    New-ADUser -Server sdc-private -Name "sales" -Description "Sales Manager" -Accountpassword $salesmanagerspw -Enabled $true -ChangePasswordAtLogon $false -Path "OU=Sales,DC=private,DC=adapt,DC=com"
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Created Sales Manager user"
}
ElseIf ($env:COMPUTERNAME -imatch 'sdc-testing') {
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Creating Admin user"
    $testadminpw= "P@sswordta"
    $testadminspw = $testadminpw | ConvertTo-SecureString -AsPlainText -Force
    New-ADUser -Server sdc-testing -Name "testadmin" -Description "test Admin" -Accountpassword $testadminspw -Enabled $true -ChangePasswordAtLogon $false -Path "OU=SysAdmin,DC=testing,DC=adapt,DC=com"
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Created Admin user"
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Adding Admin user to Admin group"
    Add-ADGroupMember -Identity "Administrators" -Members testadmin
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Adding Admin user to Admin group"
   
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Creating IT Manager user"
    $testitpw= "P@sswordti"
    $testitspw = $testitpw | ConvertTo-SecureString -AsPlainText -Force
    New-ADUser -Server sdc-testing -Name "testit" -Description "test IT Manager" -Accountpassword $testitspw -Enabled $true -ChangePasswordAtLogon $false -Path "OU=IT,DC=testing,DC=adapt,DC=com"
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Created IT Manager user"
    
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Creating Sales Manager user"
    $testsalespw= "P@sswordts"
    $testsalesspw = $testsalespw | ConvertTo-SecureString -AsPlainText -Force
    New-ADUser -Server sdc-testing -Name "testsales" -Description "test Sales Manager" -Accountpassword $testsalesspw -Enabled $true -ChangePasswordAtLogon $false -Path "OU=Sales,DC=testing,DC=adapt,DC=com"
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Created Sales Manager user"
    
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Creating HR Manager user"
    $testhrpw= "P@sswordth"
    $testhrspw = $testhrpw | ConvertTo-SecureString -AsPlainText -Force
    New-ADUser -Server sdc-testing -Name "testhr" -Description "test HR Manager" -Accountpassword $testhrspw -Enabled $true -ChangePasswordAtLogon $false -Path "OU=HR,DC=testing,DC=adapt,DC=com"
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Created HR Manager user"
}
