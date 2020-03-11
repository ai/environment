## How I install my system

### Preparing

Download [Fedora image](https://getfedora.org/ru/workstation/)
and write it to the USB drive:

```sh
sudo dnf install mediawriter
```

Write backup to external HDD:

```sh
~/environment/backup
```


### BIOS

Boot to BIOS:

1. Switch SATA to AHCI.
2. Disable Intel SpeedStep.
3. Set custom battery charge to 50/80.
4. Disable keyboard backlight and backlight timeout.


### Install

Start installer.

1. Add the Russian keyboard layout. Layout switching:
 CapsLock to the first layout, Shift+CapsLock, to the last layout.
2. Use disk manual mode. Create partitions automatically.
3. Rename volume to `foxbat`.
4. Set encryption in volume settings.
5. Remove `root` and `home`.
6. Create `root` again.

Reboot to USB drive again. Mount laptop SSD.

Open `etc/fstab`.

Add `noatime` to root partitions.

Move `/tmp` and `/var/tmp` to RAM:

```
vartmp /var/tmp tmpfs defaults,noatime 0 0
vartmp /tmp tmpfs defaults,noatime 0 0
```

Clean `tmp` and `var/tmp` dirs.

Reboot to system. Set name to `Andrey Sitnik` and login `ai`.

Copy `Dev/environment` and open `Install.md` locally.
Start to copy `.Private` and `.mozilla` in background.

Set laptop name:

```sh
sudo hostnamectl set-hostname foxbat
```

Enable TRIM:

```sh
sudo systemctl enable fstrim.timer
```

Reduce swap usage `/etc/sysctl.d/99-swappiness.conf`:

```
vm.swappiness=1
```

Disable <kbd>PgUp</kbd> and <kbd>PgDn</kbd>
`usr/share/X11/xkb/symbols/pc`:

```
    key <PGUP> { [ Left ] };
    key <PGDN> { [ Right ] };
```

Disable `Blank screen` and `Dim Screen…` in Power settings.


### System Update

Remove unnecessary packages:

```sh
sudo dnf remove cheese rhythmbox gnome-boxesd orca gnome-contacts samba-client gnome-getting-started-docs nautilus-sendto gnome-shell-extension-* libreoffice-* gnome-characters gnome-maps gnome-photos simple-scan virtualbox-guest-additions gedit gnome-boxes
```

Add RPM Fusion:

```sh
sudo dnf install --nogpgcheck http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
```

Update system:

```sh
sudo dnf update --refresh
```


### Base Settings

Enable HiDPI in TTY:

```sh
sudo dnf install terminus-fonts-console
```

Add to `/etc/vconsole.conf`:

```
KEYMAP="us"
FONT="ter-v32n"
```

Copy font:

```sh
sudo dnf install terminus-fonts-console terminus-fonts-grub2
sudo cp /usr/share/grub/ter-u32n.pf2 /boot/efi/EFI/fedora/fonts/
```

Add to `/etc/default/grub`:

```
GRUB_FONT="/boot/efi/EFI/fedora/fonts/ter-u32n.pf2"
GRUB_TERMINAL_OUTPUT="gfxterm"
```

Rebuild GRUB:

```sh
sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
```

```sh
sudo systemctl start systemd-vconsole-setup.service
```

Disable file system scanning:

```sh
dconf write /org/freedesktop/tracker/miner/files/crawling-interval -2
```

Disable sleep on lid closing:

1. `sudo nano /etc/systemd/logind.conf`
2. Ставим `HandleLidSwitch=lock`

Restart.


### Text Editors

Install nano:

```sh
su -c 'echo "export EDITOR=nano" >> /etc/profile'
```

Install VS Code:

```sh
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo dnf install code
```

Add to `/etc/sysctl.conf`:

```
fs.inotify.max_user_watches=524288
```

Install [VS Code extensions](./VSCode.md).

Install better diff:

```sh
sudo wget https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy -O /usr/local/bin/diff-so-fancy
sudo chmod a+x /usr/local/bin/diff-so-fancy
```


### Personal Files

Copy configs:

```sh
~/Dev/environment/bin/copy-env system
```

Install encryption tools:

```sh
sudo dnf install fuse-encfs
```

Open Private files and copy `.ssh/`, `.gnupg/`, and `.kube/`.

Change persmissions:

```sh
chmod 744 ~/.ssh
chmod 700 ~/.gnupg/
chmod 644 ~/.ssh/* ~/.gnupg/*
chmod 700 ~/.gnupg/private-keys-v1.d
chmod 600 ~/.ssh/id_ed25519 ~/.gnupg/private-keys-v1.d/*
```

Install 2FA reader:

```sh
sudo dnf install yubioath-desktop
```


### Terminal

Install zsh:

```sh
sudo dnf install zsh util-linux-user
chsh -s /bin/zsh
rm ~/.bash_history ~/.bash_logout
```

Install Antigen:

```sh
curl -L git.io/antigen > ~/.antigen.zsh
source ~/.antigen.zsh
```

Create `/root/.zshrc`:

```
if [ -f /home/ai/.antigen.zsh ]; then
 ANTIGEN_MUTEX=false
 source /home/ai/.antigen.zsh
 antigen bundle yarn
 antigen bundle zsh-users/zsh-syntax-highlighting
 antigen bundle zsh-users/zsh-history-substring-search
 antigen theme denysdovhan/spaceship-prompt
 antigen apply
fi

SPACESHIP_PROMPT_ORDER=(time user dir host git exit_code line_sep char)
```

Reboot.


### GNOME Settings

Install `seahorse` and disable the password for the main keychain.

Open settings:

* **Search:** keep only Calculator, Weather, and Firefox.
* **Background:** use standard GNOME wallpaper.
* **Online Accounts:** add Google account.
* **Display:** enable Night Light from 23:00 to 06:00.
* **Mouse & Touchpad:** mouse speed to 75%,
 touchpad speed to 90%, enable Tap to Click.
* **Users:** set avatar and Automatic Login.

Set keyboard settings:

```sh
dconf write /org/gnome/desktop/input-sources/xkb-options "['grp_led:caps', 'lv3:ralt_switch', 'misc:typo', 'nbsp:level3', 'lv3:lsgt_switch', 'grp:shift_caps_switch']"
```

Terminal:

* **Unnamed Profile:** disable Terminal bell.

Nautilus:

* **Views:** enable Sort folders before files.
* **Behaviour:** enable Single click to open items.

Install extensions from [`GNOME.md`](./GNOME.md).

* **Emoji selector:** disable Always show the icon.
* **Gsconnect:** add phone.
* **Icon Hider:** hide `appMenu`, `keyboard`, and its own icon.
* **Screenshot Tool:** disable Show Indicator, enable Auto-Save to Downloads
  with `{Y}{m}{d}{H}{M}{S}` name, enable Imgur Upload
  with Copy Link After Upload.

Add San Francisco, Moscow, Beijing, and Vladivostok in Clocks.

Install [JetBrains Mono](https://www.jetbrains.com/lp/mono/) font.

Install GNOME Tweaks:

```sh
sudo dnf install gnome-tweak-tool
```

* **General:** enable Over-Amplification.
* **Top Bar:** enable Battery Percentage, Date, and Seconds.
* **Window Titlebars:** Double-Click: toggle maximize vertical,
 Middle-Click: toggle maximize.
* **Keyboard & Mouse:** enable Middle Click Paste and Adaptive
 in Acceleration Profile.
* **Windows:** disable Edge Tiling.
* **Fonts:** monospace to JetBrains Mono.

Set application folder:

```sh
gsettings set org.gnome.desktop.app-folders folder-children "['Utilities']"
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Utilities/ name 'Utilities'
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Utilities/ apps "['gnome-system-log.desktop', 'gnome-system-monitor.desktop', 'org.gnome.Screenshot.desktop', 'org.gnome.DiskUtility.desktop']"
```


### Folders

Create empty file template:

```sh
mkdir ~/.local/share/desktop
mkdir ~/.local/share/templates
touch ~/.local/share/templates/Empty\ file
```

Fix folders at `~/.config/user-dirs.dirs`:

```sh
XDG_DESKTOP_DIR="$HOME/.local/share/desktop"
XDG_DOWNLOAD_DIR="$HOME/Downloads"
XDG_TEMPLATES_DIR="$HOME/.local/share/templates"
XDG_PUBLICSHARE_DIR="$HOME/"
XDG_DOCUMENTS_DIR="$HOME/"
XDG_MUSIC_DIR="$HOME/"
XDG_PICTURES_DIR="$HOME/"
XDG_VIDEOS_DIR="$HOME/Videos"
```

Clean bookmarks:

```sh
echo "" > ~/.config/gtk-3.0/bookmarks
```

Remove unnecessary folders:

```sh
rm -R ~/Documents ~/Pictures ~/Music ~/Public ~/Templates ~/Desktop
```


### Additional Software

Install codecs:

```sh
sudo dnf install amrnb amrwb faac faad2 flac gstreamer1-libav gstreamer1-plugins-bad-freeworld gstreamer-ffmpeg gstreamer-plugins-bad-nonfree gstreamer-plugins-espeak gstreamer-plugins-ugly lame libdca libmad libmatroska x264 x265 xvidcore gstreamer1-plugins-bad-free gstreamer1-plugins-base gstreamer1-plugins-good gstreamer-plugins-bad gstreamer1-plugins-ugly-free
```

Install tools:

```sh
sudo dnf install mpv unrar p7zip p7zip-plugins
```

Install Microsoft fonts:

```sh
sudo dnf install https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm
```

Install Chrome:

```sh
sudo dnf install fedora-workstation-repositories
sudo dnf config-manager --set-enabled google-chrome
sudo dnf install google-chrome-stable
```

Download [VPN config](https://www.expressvpn.com/ru/setup#manual) for Hong Kong.

Install GIMP, Telegram, Fragments, Transmission, and Zoom:

```sh
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub com.transmissionbt.Transmission de.haeckerfelix.Fragments org.telegram.desktop org.gimp.GIMP us.zoom.Zoom
```

Left only Telegram, Firefox, Nautilus, and Terminal, VS Code, Yubico 2FA,
Software in the dock.


### Development Tools

Install tools:

```sh
sudo dnf install git tig ripgrep exa
```

Install `node` and `yarn`:

```sh
sudo dnf install https://rpm.nodesource.com/pub_13.x/fc/31/x86_64/nodesource-release-fc31-1.noarch.rpm
sudo wget https://dl.yarnpkg.com/rpm/yarn.repo -O /etc/yum.repos.d/yarn.repo
sudo dnf install yarn nodejs
```

Install Ruby:

```sh
sudo dnf install ruby gcc automake gdbm-devel libffi-devel libyaml-devel openssl-devel ncurses-devel readline-devel zlib-devel gcc-c++ libxml2 libxml2-devel libxslt libxslt-devel postgresql-devel sqlite-devel ruby-devel make rpm-build
sudo dnf remove rubygem-bundler
gem install bundler
```

Install containers:

```sh
sudo dnf install podman buildah
```

```sh
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install docker-ce docker-ce-cli containerd.io
sudo systemctl start docker
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

Fix [Docker bug](https://github.com/docker/for-linux/issues/665):

```sh
sudo dnf install grubby
sudo grubby --update-kernel=ALL --args="systemd.unified_cgroup_hierarchy=0"
```

Install Keybase:

```sh
sudo dnf install https://prerelease.keybase.io/keybase_amd64.rpm
run_keybase
```

Remove Keybase from Autostart.

Install [Projecteur](https://github.com/jahnf/Projecteur#download).
