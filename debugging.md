# Errors I faced while developing this program :(
## **Error 1: Stuck at "Enabling and Configuring Shared Folders"**
- On the machine itself, press VM at the top left of the window, press install/reinstall VMware tools
- If unable to do so, check error 2

## **Error 2: "Install/reinstall VMware tools" is greyed out**
- Go to VM, Settings, press Add...,  select CD/DVD Drive, press Finish, check the option again,it should not be greyed out anymore

## **Error 3: Vagrant runs into errors because VM is stil loading**
- Use command to reload and set up again:  
vagrant reload \<vm name\> --provision

## If all else fails:
- If you think it is ***Vagrant-side*** problem, use command to reload and set up again:  
vagrant reload \<vm name\> --provision
- If you think it is ***VM-side*** problem, use command to destroy VM entirely:  
vagrant destroy \<vm name\> -f