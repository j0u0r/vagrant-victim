# Errors I faced while developing this program :(
## **Error 1: Stuck at "Enabling and Configuring Shared Folders"**
- On the machine itself, press VM at the top left of the window, press install/reinstall VMware tools.
- If unable to do so, check error 2.

## **Error 2: "Install/reinstall VMware tools" is greyed out**
- Go to VM, Settings, press Add...,  select CD/DVD Drive, press Finish, check the option again,it should not be greyed out anymore.

## **Error 3: Vagrant runs into errors because VM is still loading**
- Use command to reload and set up again:  
vagrant reload \<vm name\> --provision

## **Error 4: Vagrant stuck at "Waiting for machine to reboot..."**
- In host machine's Powershell terminal press ***CONTROL + C*** and wait for vagrant's process to stop.
- Use command to reload and set up again:  
vagrant reload \<vm name\> --provision

## **Error 5: Vagrant destroy results in a lot of errors**
- From my observation, it doesn't seem to impact much and the VM seems to be successfully destroyed, but if you want to solve this issue, got to /Vagrant/.vagrant/machines and delete the folder with the respective VM name.

## **Error 6: Install-ADDSDomain: Verification of prerequisites for Domain Controller promotion failed. Failed to detect component binaries**
- Use command to destroy ALL domain controllers, including subdomain controllers:  
vagrant destroy \<dc vm name\>, \<sdc vm name\> --f
- Use command to set up AD environment again:  
vagrant up

## **Error 7: An authorisation error occurred while connecting to WinRM**
- Use command to reload and set up again:  
vagrant reload \<vm name\> --provision

## **Error 8: "The following WinRM command responded with a non-zero exit status. Vagrant assumes that this means the command failed!" while configuring OUs/users**
- Check the error message. Usually i get "An unspecified error has occurred... RemoteException... NativeCommandError"
- Not too sure what the problem is...

## **Error 9: The provider "vmware_desktop" could not be found. Please use a provider that exists**
- Run this command using Powershell terminal:  
vagrant plugin install vagrant-vmware-desktop

## **Error 10: (USING VM AS HOST MACHINE) VMware opens then immediately closes, Vagrant runs into unknown error**
- Shut down the VM that you are hosting Vagrant on, on the top press VM, Settings..., Processors, tick 'Virtualize Intel VT-x/EPT or AMD-V/RVI

## If all else fails:
- If you think it is ***Vagrant-side*** problem, use command to reload and set up again:  
vagrant reload \<vm name\> --provision
- If you think it is ***VM-side*** problem, use command to destroy VM entirely:  
vagrant destroy \<vm name\> -f
