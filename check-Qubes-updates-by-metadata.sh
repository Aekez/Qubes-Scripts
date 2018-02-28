#!/bin/sh

##Note - Despite that the script works, it is not finished yet and is still in an experimental state.

#Title description
##Unofficial Qubes Maintenance Updater (uQMU).

#>>>>WARNING!<<<<
##Please read the script carefully, do not run if you do not know what it does.
##Be sure you edit it correctly to your own needs.

#Disclaimer:
##Coding is not my profession, nor do I have deep insight into advanced scripting.
##Feel free to critesize and suggest constructive improvements.

#Author:
##Aekez @ github.

#Quick purpose overview:
##This script performs auto-updates of dom0 and every default template. The script is
##highly customizeable, warning message/Quick-Backup/repositories, can be adjusted or
##disabled. It also includes a quick optional qvm-backup reminder/starter. If you use
##backup profiles instead of manually configuring which VMs to include or exclude in
##the qvm-backup, then all you need to do is to adjust the qvm-backup command below,
##similar to how you normally would execute the command in dom0 terminal.

#Important notes
##1) Be sure you have enough free RAM to run the largest RAM intensive template, one at a time.
##2) The script will halt if it is interupted, such as not enoguh RAM.
##3) VM's will shutdown automatically if no updates, or after succesfull update install.
##4) You may include the -y option to auto-accept updates in some VMs, be careful though.
##5) You can disable the Quick Backup, however if you use it then remember to configure it.
##6) Add or remove '#̈́' in front of the command instructions to disable/enable commands.
##7) Reminder: Always consider a full system reboot if you accepted dom0 updates.
##8) Reminder: Always consider restarting AppVMs if you accepted template updates.
##9) The purpose of --check-only & --refresh is to only download what is needed, metadata.
#10) Should metata determine available updates, it will then still offer to update like normal.
#11) The reduction of overhead downloads, ethically allows for more frequent update checks.
#12) Its essential to keep dom0/templates in sync between repositories & cache expirations.
#13) This script essentially does just that, systematically removing mistakes, making it easier.
#14) Repositories must be in sync, such as between stable & current-testing for dom0/tempaltes.
#15) Script is for normal use, security-testing & unstable-testing repositories are not included.
#16) Only use current-testing if you know what you are getting yourself into, it is untested.
#17) This script release version is only tested on Qubes 4.0.

#Script weaknesses
##1) Script failing halfway through, without being detected (it can fail silently, i.e if out of
##   RAM. However it will on the other hand post a message if it succesfully makes it through.
##2) Mis-configuration of the script, for example mixing current-testing with stable repositories.
##3) Other potential issues that were not predicted.

#Warning message
##This warning meesage can be disabled with a #. It includes essential warning for new users
##not aware of the pitfalls of scripts. Its highly recommended that new users study how the
##script works, it's not very complicated, but also not straight simple either.
zenity --width="420" --height="200" --title="Welcome to uQMU!" --info --text='This script allows you to easily keep Qubes 4 in a good state with proper maintenance.\n\n\- Warning! Please read the comments inside the script carefully before running this script.\n\n- The script is out-of-the-box safety locked, you need to edit the "#" to enable features. Quick Backup and Reboot prompt are by default enabled, as you will notice when you click "ok" below. Please decline the next two prompts, and then edit the script for your needs.\n\n Please do not use Quick Backup before you manually adjusted it to your needs inside the script.'
wait

#Quick Backup Redundancy
##The purpose here is to serve as a reminder to backup before performing updates, which always
##carries a risk of making the system unbootable. This serves as a popup message, which you
##can decline to continue without starting qvm-backup, or click yes to perform your qvm-backup.
##Keep in mind you need to adjust it below to your own customized qvm-backup. The default will
##only exclude system dom0 & default templates. However a proper path/src-VM is still required.
##Remember to put the backup externally, so that you can access it if the system does not boot.
##Partial credit for this section rhss6-2011 @ https://ubuntuforums.org/showthread.php?t=2239195
ans=$(zenity --width="420" --height="200" --title="uQMU - Quick Backup." --question --text='Do you want to perform a quick backup of your pre-selected AppVMs?' --ok-label="Yes" --cancel-label="No"
if [ $? = 0 ] ; then
command=$(xterm -geometry 100x45+500+250 -background black -foreground white -e qvm-backup -d src-AppVM '/home/user/' -x fedora-26 -x debian-9 -x whonix-ws -x whonix-gw -x sys-net -x sys-firewall -x sys-usb -x sys-whonix -x fedora-26-dvm -x whonix-ws-dvm -x anon-whonix -x fedora-26-minimal
else
command=$()
fi
)
wait


##Qubes dom0 updates
#xterm -e 'sudo qubes-dom0-update --check-only'
#xterm -e 'sudo qubes-dom0-update --enablerepo=qubes-dom0-current-testing --check-only'

wait


##Default Qubes fedora template
#qvm-run fedora-26 'xterm -e sudo dnf update --refresh'
#qvm-run fedora-26 'xterm -e sudo dnf update --enablerepo=qubes-vm-*-current-testing --refresh'

wait
qvm-shutdown fedora-26
wait


##To be removed in officail release, cloned template.
#qvm-run fedora-26-apps 'xterm -e sudo dnf update --refresh'
#qvm-run fedora-26-apps 'xterm -e sudo dnf update --enablerepo=qubes-vm-*-current-testing --refresh'

wait
qvm-shutdown fedora-26-apps
wait


##Default Qubes debian template.
#qvm-run debian-9 'xterm -e sudo apt-get update && apt-get dist-upgrade'

wait
qvm-shutdown debian-9
wait

qvm-stat sys-whonix
wait

##Default Qubes Whonix-WS
#qvm-run whonix-ws 'xterm -e sudo apt-get update && apt-get dist-upgrade'

wait
qvm-shutdown whonix-ws
wait


##Default Qubes Whonix-GW
#qvm-run whonix-gw 'xterm -e sudo apt-get update && apt-get dist-upgrade'

wait
qvm-shutdown whonix-gw
wait

#qvm-shutdown sys-whonix
wait

##Conclusion: Question message, whether to restart or not. Copied logic, credit goes
##to rhss6-2011 @ https://ubuntuforums.org/showthread.php?t=2239195
ans=$(zenity --width="420" --height="200" --title="UQU has reached its conclusion." --question --text='The update-script has reached its conflusion.\n\n- Click "Yes" to perform a full system restart,\nthis is normally needed after dom0 updates.\n\n- Click "No" if no restart is required or you wish\nto restart manually later. This is normally preferred\nfor template only updates.' --ok-label="Yes" --cancel-label="No"
if [ $? = 0 ] ; then
command=$(xterm -e shutdown -h now)
##use 'reboot -r now' instead of shutdown if you want the 'Yes' button to perform a reboot.
else
command=$()
fi
)
