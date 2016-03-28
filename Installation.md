Summary
==
Install the utilities listed below in the order that they are listed. Where possible within reason, the installations are scripted, however multiple manual steps remain.

Chocolatey
==
1. Install chocolatey.
	https://chocolatey.org/

Initial Scripts
==

Bootstrap Script
--
1. Download MyDevSetup from (https://github.com/Vector241-Eric/MyDevSetup/archive/master.zip).
1. Unzip into the temp directory of your choice.
1. Open a powershell console as **Administrator**.
1. Execute `Set-ExecutionPolicy Unrestricted`.
1. CD to the location where you unzipped MyDevSetup.
1. Execute `Bootstrap-DevelopmentMachine.ps1`.
1. **Close the current Powershell window.**

Second script
--
1. Open a new Powershell window as **Administrator**
1. Change directory to the location where you unzipped MyDevSetup.
1. Execute `Scripts\Initialize-PostInstallSettings.ps1`

Setup Github
==
Create a Github.com account if you don't already have one.

Setup SSH
==
Follow these steps so that you can authenticate via SSH with Github rather than using HTTPS and passwords. The bootstrap script should have already installed the needed utilities, these steps will walk you through generating a key and configuring the SSH tools to play nicely with git.

Generate an SSH Key
--
1. Execute `Start --> puttygen`.
1. At the bottom of the dialog, select "SSH-2 RSA".
1. Click "Generate" and move the mouse as directed.
1. Enter a passphrase and matching confirmation value into the dialog.
1. Save the private key. Put this somewhere you want to keep it since this is the file that will be loaded when you boot your machine.
1. Login to Github
1. Navigate to https://github.com/settings/keys
1. Click the "New SSH key" button
1. Give your key a good title. I like to put the hostname in the title so I know I can delete it in the future.
1. Copy the entire contents of the text area at the top of the puttgen dialog.
1. Paste into the text area on Github and Save.
1. Close puttygen.

Setup pageant
--
These steps configure pageant to load your key each time you boot. Once this is setup, you'll be asked for your Github key password when you login, then SSH auth is completely configured for git.

**Loading the Key**

These steps verify that the key can be loaded into Pageant.

1. Execute `Start --> Pageant`. This will give you an icon in the system tray.
1. Double Click the Pageant icon in the system tray to show the Pageant Key List
1. Click "Add Key"
	1. Navigate to the private key file that you saved earlier, and select it.
	1. Enter the password and the dialog should disappear.
	1. You can double check that the key has been loaded by double-clicking the pageant icon in the system tray again. The key should now be listed.

**Creating Automatic Startup**	 

These steps create a shortcut in the StartUp folder and **register the SSH tools with Git**. If you don't wish for Pageant to start automatically, then you can remove the shortcut from the startup folder. Or, you can setup your `GIT_SSH` environment variable to point to the `plink.exe` and skip running this script. The easiest thing to do is to allow the script to set everything up for you.

For this, you'll need:
* The path to the MyDevSetup folder (where you unzipped it above).
* The path to the private key (*.ppk) file you saved earlier

1. Open a powershell console as **Administrator**.
1. CD to the location where you unzipped the MyDevSetup folder.
1. Execute `Scripts\Register-PageantStartupSettings.ps1 <path to .ppk file>`
1. From the powershell command line, execute `putty github.com`. This should prompt you to accept the fingerprint of the Github server.

Git SSH is now setup.

Git Comparison Tool (optional)
==
Some instructions for setting up an alternate comparison / merge tool for git.

Beyond Compare
--
1. Download Beyond Compare from http://www.scootersoftware.com/index.php
1. Run the installation program
1. Open powershell
1. Execute `git config --global diff.tool bc`
1. Execute `git config --global difftool.bc.path "c:/Program Files/Beyond Compare 4/bcomp.exe"`

**To Use Pro Version 3-way Merge**

1. Execute `git config --global merge.tool bc`
1. Execute `git config --global mergetool.bc.path "c:/Program Files/Beyond Compare 4/bcomp.exe"`

Make It Unix-y (optional)
==
Old habits die hard. I've spent enough time on Unix / linux boxes that those commandline utilities are still readily under my fingers. I still prefer some of them, so I install the GnuWin32 utilities rather than a completely new shell. This allows me to use some Unix commands in the Powershell consoles.

Install gnuwin32
--
1. Open a powershell console as **Administrator**.
1. Execute `choco install gnuwin32-coreutils.install`
1. Execute `Add-PathToEnvironment 'C:\Program Files (x86)\GnuWin32\bin'` This *Add-PathEnvironmentVariable* command should have been installed via your profile much earlier in the process

1. Download GnuWin32 which.exe utility, unzip, and copy into the bin directory

	    http://gnuwin32.sourceforge.net/packages/which.htm
	    Click to download Binaries/Zip

Install VIM
--
`choco install vim`
