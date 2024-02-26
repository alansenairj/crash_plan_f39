
# CRASH PLAN - BACKUP 321 - SECOND COPY PLAN

```
- TOOLs - RSYNC, FWBACKUP, BORG, VORTA
- MEDIAS - USB / SMB / NVME
- RSYNC SCRIPT PATH - /home/alan/scripts
- CRON SCHEDULING SCRIPTS - ROOT / ALAN
```

# setup rsync log
```
❯ sudo mkdir -p /var/log/rsync/
❯ sudo chown root:alan /var/log/rsync/
❯ sudo chmod 775 /var/log/rsync/
❯ sudo touch /var/log/rsync/rsync.log
❯ sudo chown root:alan /var/log/rsync/rsync.log
❯ sudo chmod 664 /var/log/rsync/rsync.log
```

# READ LOGS
```
less /var/log/rsync/rsync.log
```
# PATH TABLES

| PATH SOURCE | USB  |  SMB | ROTINE  |  FWBACKUP |
|---|---|---|---|---|
| /home/alan/  | /mnt/sdd1/console_home_dotfiles  | /home/alan/tplink-share/console_home_dotfiles  | DOT FILES  | FWBACKUP  |
|  /home/alan/.config/filezilla |  /mnt/sdd1/critical_settings/filezilla/ |  /home/alan/tplink-share/critical_settings/filezilla/ |  FILEZILLA | FWBACKUP  |
|  /home/alan | /mnt/sdd1/critical_settings/joplin/  | /home/alan/tplink-share/critical_settings/joplin/  |  JOPLIN | FWBACKUP  |
|  /home/alan/OneDrive/keepass/ | /mnt/sdd1/keepass/alan/  | /home/alan/tplink-share/keepass/alan/  | KEEPASS ALAN  | FWBACKUP  |
| /home/alan/csi_senhas/  | /mnt/sdd1/keepass/csi/  |  /home/alan/tplink-share/keepass/csi/ |  KEEPASS CSI |  FWBACKUP |
|  /mnt/sdd1/clonezilla_images/ |  /mnt/sdd1/clonezilla_images/ |  /home/alan/tplink-share/clonezilla_images/ |  OS TO NVME |  FWBACKUP |
| /home/alan/.var/app/org.remmina.Remmina/data/remmina  | /mnt/sdd1/critical_settings/remina/  |  /home/alan/tplink-share/critical_settings/remina/ | REMINA  |  FWBACKUP |
| /home/alan/.ssh  | /mnt/sdd1/critical_settings/ssh_backups  | /home/alan/tplink-share/critical_settings/ssh_backups  | SSH  | FWBACKUP  |
| /home/alan/themes/konsave  | /mnt/sdd1/themes/konsave  | /home/alan/tplink-share/themes/konsave  | KONSAVE  |  FWBACKUP |
| /var/spool/cron  | /mnt/sdd1/critical_settings/cron/  | /home/alan/tplink-share/critical_settings/cron/  | CRON  |  RSYNC |
|  /etc/dnf/dnf.conf | /mnt/sdd1/critical_settings/dnf/  |  /home/alan/tplink-share/critical_settings/dnf/ | DNF  | RSYNC  |
| /etc/fstab  | /mnt/sdd1/critical_settings/fstab/  | /home/alan/tplink-share/critical_settings/fstab/  | FSTAB  | RSYNC  |
| /etc/systemd/system/rclone.service  | /mnt/sdd1/critical_settings/rcloneservice/  | /home/alan/tplink-share/critical_settings/rcloneservice/  | RCLONE  | RSYNC  |
| /etc/samba/smb.conf  | /mnt/sdd1/critical_settings/samba/  | /home/alan/tplink-share/critical_settings/samba/  |  SAMBA CONF | RSYNC  |
| /usr/share/sddm/themes  | /mnt/sdd1/themes/sddm_login_screen/  |  /home/alan/tplink-share/themes/sddm_login_screen/ | LOGIN SCREEN  | RSYNC  |
| /etc/xdg/autostart/solaar.desktop  |  /mnt/sdd1/critical_settings/solaar_mouse/ | /home/alan/tplink-share/critical_settings/solaar_mouse/  | MOUSE  |  RSYNC |
| /etc/NetworkManager/system-connections  | /mnt/sdd1/critical_settings/NetworkManager_VPN/  |  /home/alan/tplink-share/critical_settings/NetworkManager_VPN/ |  VPN |  RSYNC |
| /etc/yum.repos.d  | /mnt/sdd1/critical_settings/yumrepos/  | /home/alan/tplink-share/critical_settings/yumrepos/  | REPOS DNF  | RSYNC  |

# SCHEDULING TABLE

| HOUR  | DAY   | WEEK | MONTH  | YEAR  |
|---|---|---|---|---|
| KEEPASS ALAN  | SSH  | FSTAB  | DNF  | HOME  |
| KEEPASS CSI  | BORG HOME  | KONSAVE  | DOT FILES  |   |
|   | FILEZILLA  |   | CRON  |   |
|   | REMINA  |   | SAMBA CONF  |   |
|   | JOPLIN  |   |  LOGIN SCREEN |   |
|   | VPN  |   | OS TO NVME  |   |
|   |   |   | MOUSE  |   |
|   |   |   |   |   |
|   |   |   |   |   |


# ROOT CRONTAB SCHEDULE -  https://crontab.guru/examples.html

```
SHELL=/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=root

# For details see man 4 crontabs

# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * user-name  command to be executed

# por hora


# por dia
0 9 * * *  "/home/alan/scripts/usb/root/rsync_vpnconex_usb_sync.sh" >/dev/null
02 9 * * * "/home/alan/scripts/smb/root/rsync_vpnconex_smb_sync.sh" >/dev/null

# semana
0 9 * * 2  "/home/alan/scripts/usb/root/rsync_fstab_usb_sync.sh" >/dev/null
02 9 * * 2 "/home/alan/scripts/smb/root/rsync_fstab_smb_sync.sh" >/dev/null
05 9 * * 2 "/home/alan/scripts/usb/root/rsync_yumrepos_usb_sync.sh" >/dev/null
09 9 * * 2 "/home/alan/scripts/smb/root/rsync_yumrepos_smb_sync.sh" >/dev/null

# por mes
0 10 1 * *  "/home/alan/scripts/smb/root/rsync_dnf_smb_sync.sh" >/dev/null
01 10 1 * * "/home/alan/scripts/usb/root/rsync_dnf_usb_sync.sh" >/dev/null
02 10 1 * * "/home/alan/scripts/smb/root/rsync_crontab_smb_sync.sh" >/dev/null
03 10 1 * * "/home/alan/scripts/usb/root/rsync_crontab_usb_sync.sh" >/dev/null
04 10 1 * * "/home/alan/scripts/usb/root/rsync_sambaconf_usb_sync.sh" >/dev/null
05 10 1 * * "/home/alan/scripts/smb/root/rsync_sambaconf_smb_sync.sh" >/dev/null
06 10 1 * * "/home/alan/scripts/usb/root/rsync_sddm_login_usb_sync.sh" >/dev/null
07 10 1 * * "/home/alan/scripts/smb/root/rsync_sddm_login_smb_sync.sh" >/dev/null
08 10 1 * * "/home/alan/scripts/usb/root/rsync_rcloneservice_usb.sh" >/dev/null
09 10 1 * * "/home/alan/scripts/smb/root/rsync_rcloneservice_smb_sync.sh" >/dev/null
10 10 1 * * "/home/alan/scripts/usb/root/rsync_solaar_mouse_usb_sync.sh" >/dev/null
11 10 1 * * "/home/alan/scripts/smb/root/rsync_solaar_mouse_smb_sync.sh" >/dev/null
12 10 1 * * "/home/alan/scripts/usb/root/rsync_themes_usb_sync.sh" >/dev/null
13 10 1 * * "/home/alan/scripts/smb/root/rsync_themes_smb_sync.sh" >/dev/null

#por ano


```


# SOURCE TARGETS

## timeshift
/mnt/sdf1/timeshift/

## borg_home
/mnt/sdd1/backup_home/

## yum.repos.d
/etc/yum.repos.d/

## .ssh CONFS
/home/alan/.ssh/

## ZSH_DOT_FILES
/home/alan//home/alan/.oh-my-zsh/
.bash_history
.bashrc
.p10k.zsh
.zsh_history
.zshrc

## keepass alan
/home/alan/OneDrive/keepass/

## keepass csi
/home/alan/csi_senhas/

## crontabs
/var/spool/cron/

## fstab
/etc/fstab

## joplin
/home/alan/.config/Joplin/
/home/alan/.config/joplin-desktop/

## Filezilla
/home/alan/.config/filezilla/

remina 
/home/alan/.var/app/org.remmina.Remmina/data/remmina/

# DESTINATION USB TARGETS

## DOT_FILES

```
DEST_DIR="/mnt/sdd1/console_home_dotfiles/"
FILES_TO_RSYNC=(
    "$SOURCE_DIR/.oh-my-zsh"
    "$SOURCE_DIR/.bash_history"
    "$SOURCE_DIR/.bashrc"
    "$SOURCE_DIR/.p10k.zsh"
    "$SOURCE_DIR/.zsh_history"
    "$SOURCE_DIR/.zshrc"
```
## FILEZILLA
DEST_DIR="/mnt/sdd1/critical_settings/filezilla/"

## JOPLIN
DEST_DIR="/mnt/sdd1/critical_settings/joplin/"

## KEEPASS DB ALAN
DEST="/mnt/sdd1/keepass/alan/"

## KEEPASS DB CSI
DEST="/mnt/sdd1/keepass/csi/"

## USB TO NVME OS CLONEZILLA IMG
DEST_DIR="/mnt/sdf1/"

## REMINA CONECTIONS
DEST="/mnt/sdd1/critical_settings/remina/"

## SSH 
DEST="/mnt/sdd1/critical_settings/ssh/"

## CRONTAB
DEST="/mnt/sdd1/critical_settings/crontab/"

## FSTAB
DEST="/mnt/sdd1/critical_settings/fstab/"

## YUM REPOS
DEST="/mnt/sdd1/critical_settings/yumrepos/"

# DNF
/etc/dnf/dnf.conf

# SAMBA
/etc/samba/smb.conf


# Vorta / borg ignore 

    --exclude /home/alan/tplink-share/ \
    --exclude /home/alan/VirtualBox_VMs/ \
    --exclude /home/*/VirtualBox_VMs/ \
    --exclude /home/*/.cache/* \
    --exclude /home/alan/log/ \
    --exclude /home/alan/logs/ \
    --exclude /home/alan/New\ Folder/


# OS RECONFIGURE - APPS, FIXES AND CONFIGURATIONS

### marcar os que tem que baixar rmp 
- vpn
- virtual VirtualBox
- nvidia
- libs
- anydesk


# REPOSITORIES

```
sudo rpm -i https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm

sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
cat <<EOF | sudo tee /etc/yum.repos.d/vscode.repo\n[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc\nEOF

```


# fucking polikit to update bug

- sudo usermod -aG wheel alan
- put USER alan on whell - visudo
- uncomment %whell NOPASSWD line
https://wiki.archlinux.org/title/Polkit#Bypass_password_prompt

## INSTALL ANYDESK
```
sudo tee /etc/yum.repos.d/AnyDesk-Fedora.repo <<EOF
[anydesk]
name=AnyDesk Fedora - stable
baseurl=http://rpm.anydesk.com/centos/x86_64/
gpgcheck=0
repo_gpgcheck=0
gpgkey=https://keys.anydesk.com/repos/RPM-GPG-KEY
EOF
```

# PAKAGES

```
sudo dnf install vim
sudo dnf makecache
sudo dnf install -y git git-lfs
sudo dnf install -y java-latest-openjdk
sudo dnf install -y curl cabextract xorg-x11-font-utils fontconfig
sudo dnf install -y unzip p7zip p7zip-plugins unrar
sudo dnf install -y 'google-roboto*' 'mozilla-fira*' fira-code-fonts
sudo dnf install dnf5 dnf5-plugins
sudo dnf install google-chrome-stable
sudo dnf install rpmconf
sudo dnf install input-leap
sudo dnf install code
sudo dnf install partclone
sudo dnf install timeshift
sudo dnf install bleachbit.noarch
sudo dnf install bat
# sudo dnf install eza ( NOT GOOD FOR SCRIPTS. LS IS BETTER)
sudo dnf install ripgrep
sudo dnf install python3-pip
sudo dnf -y install @development-tools
sudo dnf -y install kernel-headers kernel-devel dkms elfutils-libelf-devel qt5-qtx11extras
sudo dnf install redhat-lsb-core anydesk
sudo dnf install keepassxc
sudo dnf group upgrade --with-optional Multimedia
sudo dnf install mpv mpv-libs
sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install dnf-plugins-core -y
sudo dnf group update core
sudo dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
sudo dnf groupupdate sound-and-video
sudo dnf install mc bpytop inxi ncdu tmux neofetch qbittorrent
sudo dnf config-manager --set-enabled fedora-cisco-openh264
sudo dnf install -y openh264 gstreamer1-plugin-openh264 mozilla-openh264
sudo dnf install  solaar.noarch
sudo dnf install  solaar-udev.noarch
sudo dnf insatall gimp
sudo dnf install openfortivpn
sudo dnf install esmtp-local-delivery
sudo dnf install moreutils.x86_64
hdparm-9.65-2.fc39.x86_64
grsync-1.3.1-1.fc39.x86_64
borgbackup-1.2.7-1.fc39.x86_64
syncthing-1.27.2-1.fc39.x86_64
qbittorrent-1:4.6.2-1.fc39.x86_64
ncdu-1.19-1.fc39.x86_64
bpytop-1.0.68-5.fc39.noarch
openh264-2.3.1-2.fc39.x86_64
mozilla-openh264-2.3.1-2.fc39.x86_64
gstreamer1-plugin-openh264-1.22.1-1.fc39.x86_64
wireshark-1:4.0.8-2.fc39.x86_64
samba-2:4.19.4-3.fc39.x86_64
timeshift-22.11.2-2.fc39.x86_64
ripgrep-14.0.3-1.fc39.x86_64
python3-pip-23.2.1-1.fc39.noarch
easyeffects-7.1.3-1.fc39.x86_64
sudo dnf install virt-viewer
sudo dnf install cheat.x86_64
```

# docker
 curl -fsSL https://get.docker.com -o get-docker.sh
 sudo sh get-docker.sh


 sudo systemctl enable docker.service --now
 sudo groupadd -f docker
 sudo usermod -aG docker $USER
 newgrp docker

# docker-compose
```

sudo curl -L "https://github.com/docker/compose/releases/download/v2.5.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose  
sudo chmod +x /usr/local/bin/docker-compose

```
# KONSAVE - SAVE KDE THEME SETTINGS

## INSTALL
```
python -m pip install konsave
Dependencies
There are no dependencies! Just make sure your python version is above 3.8.

Installation
Clone This repo
git clone https://github.com/Prayag2/konsave ~/Downloads/konsave

Make it executable
cd ~/Downloads/konsave sudo chmod +x ./install.sh

Install
./install.sh
```

## Konsave Usage

### Get Help
konsave -h

### Save current configuration as a profile
konsave -s <profile name>

### List all profiles
konsave -l

### Remove a profile
konsave -r <profile id>

### Apply a profile
konsave -a <profile id>
!!! You may need to log out and log in to see all the changes.!!!
!!! if a profile has same name it cannot be imported !!! 


## USE AND CREATE THEME BACKUP

```
--apply <name>
 -i <path>, --import-profile <path>
 -e <name>, --export-profile <name>
```

## COMMAND
```
CREATE BACKUP
/home/alan/.local/bin/konsave -f -s f39plasma -d /mnt/sdd1/themes/konsave/
```

## PATHS
```
/home/alan/.config/konsave/profiles/f39plasma
/usr/share/sddm/
/usr/share/sddm/themes/
/home/alan/.config/konsave/profiles/
```

# MANUAL THEME APPLY AS SECOND SOURCE
```
plasma-apply-colorscheme
plasma-apply-cursortheme
plasma-apply-desktoptheme
plasma-apply-lookandfeel
plasma-apply-wallpaperimage
```
usage example:
- plasma-apply-desktoptheme --list-themes
- plasma-apply-desktoptheme breeze-dark


# THIRD OPTION TO MANAGE THEMES
```
systemctl enable sddm.service # if it isn't enabled yet

if [ -d /usr/share/sddm/themes ]; then
cp -a ${HOME}/insertNameOfDir/Sweet /usr/share/sddm/themes/
else mkdir -p /usr/share/sddm/themes && cp -a ${HOME}/insertNameOfDir/Sweet /usr/share/sddm/themes;
fi
cat < /etc/sddm.conf
[Theme]
Current=Sweet
EOF
```

# CONFIGURE SAMBA
```
sudo dnf install samba
cat <<EOF >> /etc/samba/smb.conf
[alan]
   path = /home/alan
        writeable = yes
        browseable = yes
        public = yes
        create mask = 0644
        directory mask = 0755
        write list = user
EOF

sudo systemctl enable smb --now
smbpasswd -a -n alan
sudo systemctl restart smb
tail -f /var/log/samba/log.smbd
```

# SHARED NAS FOLDERS NOT MOUNTING AT STARTUP

```
sudo systemctl enable NetworkManager-wait-online.service

```


# globalprotect GUI install FOR MICROSOFT OAUTH
```
sudo yum localinstall globalprotect-openconnect-snapshot-1.4.6+2snapshot.g5714063-1.1.x86_64.rpm
sudo vi /etc/gpservice/gp.conf
sudo pip3 install "vpn-slice[dnspython,setproctitle]"
sudo vpn-slice --self-test
```

# Whireshark
```
sudo dnf install wireshark-1:4.0.8-2.fc39.x86_64
sudo usermod -a -G wireshark alan
sudo chmod a+x /usr/bin/dumpcap
```

# VirtualBox
```
yum localinstall VirtualBox-7.0-7.0.14_161095_fedora36-1.x86_64.rpm
sudo yum localinstall VirtualBox-7.0-7.0.14_161095_fedora36-1.x86_64.rpm
sudo systemctl enable vboxdrv --now
systemctl status vboxdrv.service
sudo usermod -aG vboxusers $USER
```

# mcfly
```
curl -LSfs https://raw.githubusercontent.com/cantino/mcfly/master/ci/install.sh | sudo sh -s -- --git cantino/mcfly
eval "$(mcfly init zsh)"
```

# backgroud login screen
```
mv 5120x2880.png 5120x2880.png.old
cp /home/alan/themes/wall.jpg .
rm -rf wall.jpg
cp /home/alan/themes/wall.png .
mv wall.png 5120x2880.png
vi theme.conf
```


# TWEAKS

```
sudo systemctl disable NetworkManager-wait-online.service
sudo nano /etc/systemd/system.conf
DefaultTimeoutStartSec=15s
DefaultTimeoutStopSec=15s
sudo vi /etc/dnf/dnf.conf
max_parallel_downloads=10
deltarpm=true

sudo fwupdmgr get-devices
sudo fwupdmgr get-updates
```

## FIREWALL AND SELINUX
```
systemctl stop firewalld
cd /etc/selinux
sudo vi config
SELINUX=0
systemctl disable firewalld
```

# powerlevel10k
```
sudo dnf install zsh
chsh -s $(which zsh)
zsh
exec $SHELL
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
chsh -s $(which zsh)
git clone --depth=1 https://gitee.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
vi .zshrc
source .zshrc
p10k configure
```

# FLATPAKS
```
flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install easyeffects
flatpak install teams-for-linux
flatpack install org.freeplane.App/x86_64/stable
io.github.peazip.PeaZip
io.github.peazip.PeaZip.Addon.i386
com.jgraph.drawio.desktop
com.spotify.Client
org.freeplane.App
```

# CLEAN KERNELS
```
chmod +x ./removeoldkernels.sh
./removeoldkernels.sh
reboot
```

# Java install - download compacted file at oracle site - individual users - alan/root
```
mkdir -p /usr/local/java
cp /home/alan/Downloads/jdk-21_linux-x64_bin.tar.gz /usr/local/java
cd /usr/local/java
tar -xvzf jdk-21_linux-x64_bin.tar.gz
cd jdk-21.0.2

vi /etc/profile
   #java
JAVA_HOME=/usr/local/java/jdk-21.0.2
PATH=$PATH:$HOME/bin:$JAVA_HOME/bin
export JAVA_HOME
export PATH
```

## user root
```
update-alternatives --install "/usr/bin/java" "java" "/usr/local/java/jdk-21.0.2/bin/java" 1
update-alternatives --install "/usr/bin/javac" "javac" "/usr/local/java/jdk-21.0.2/bin/javac" 1
update-alternatives --install "/usr/bin/javaws.itweb" "javaws.itweb" "/usr/local/java/jdk-21.0.2/bin/javaws.itweb" 1
update-alternatives --set java /usr/local/java/jdk-21.0.2/bin/java
update-alternatives --set javac /usr/local/java/jdk-21.0.2/bin/javac
update-alternatives --set javaws.itweb /usr/local/java/jdk-21.0.2/bin/javaws.itweb
source /etc/profile
exec $SHELL
jar --version
echo $JAVA_HOME
cd
vi .zshrc
```

   #Java
```
export JAVA_HOME=/usr/local/java/jdk-21.0.2
```

## user alan
```
sudo update-alternatives --install "/usr/bin/java" "java" "/usr/local/java/jdk-21.0.2/bin/java" 1
sudo update-alternatives --install "/usr/bin/jar" "jar" "/usr/local/java/jdk-21.0.2/bin/jar" 1
sudo update-alternatives --set java /usr/local/java/jdk-21.0.2/bin/java
sudo update-alternatives --set jar /usr/local/java/jdk-21.0.2/bin/jar
source .zshrc
```
## test
```
java
jar
jar --version
jar
java --version
jar --version
```
# for all users aproach - worked well doing script in profile.d
ex for java 1.8:
```
tar -xvf jdk-8u391-linux-x64.tar.gz
mv jdk1.8.0_391/ /opt
:>/etc/profile.d/java.sh
chmod a+x /etc/profile.d/java.sh
vi /etc/profile.d/java.sh

#!/bin/bash
export JAVA_HOME=/opt/jdk1.8.0_391
export PATH=$JAVA_HOME/bin:$PATH

```

# Nvidia install - not perfect. 
use this guide - https://www.if-not-true-then-false.com/2015/fedora-nvidia-guide/#210-all-is-done-and-then-reboot-back-to-runlevel-5
```
sudo dnf remove akmod-nvidia xorg-x11-drv-nvidia-cuda
reboot
sudo dnf remove xorg-x11-drv-nvidia\*
sudo dnf install akmod-nvidia-3:535.129.03-1.fc39.x86_64
sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$\(rpm -E %fedora).noarch.rpm
lspci |grep -E "VGA|3D"
mokutil --sb-state
cd Downloads
chmod +x NVIDIA-Linux-x86_64-545.29.06.run
sudo su
sudo dnf remove xorg-x11-drv-nouveau
sudo dnf -y remove kmod-nvidia
sudo dnf remove xorg-x11-drv-nvidia-cuda
sudo dnf remove akmod-nvidia
sudo dnf remove xorg-x11-drv-nvidia-cuda
nvidia-smi
sudo dnf remove akmod-nvidia
cd Downloads/
./NVIDIA-Linux-x86_64-495.44.run 
sudo ./NVIDIA-Linux-x86_64-495.44.run 
cat /var/log/nvidia-installer.log |less
sudo ./NVIDIA-Linux-x86_64-495.44.run 
sudo akmods --force && sudo dracut --force
sudo akdods --force && dracut --force
sudo grubby --update-kernel=ALL --args='nvidia-drm.modeset=1'
```

# vpau for firefox - not tested
```
sudo dnf install nvidia-vaapi-driver libva-utils vdpauinfo
```