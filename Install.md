## How I install my system

### Preparing

Download [Fedora image](https://getfedora.org/ru/workstation/)
and write it to the USB drive:

```sh
sudo dnf install mediawriter
```

Write backup to external HDD:

```sh
~/environment/bin/backup
```


### BIOS

Boot to BIOS:

1. Swap Fn and Ctrl.
2. Switch to Linux sleep mode.
3. Set custom battery charge to 50/80.
4. Set BIOS password.


### Install

Start installer.

1. Add the Russian keyboard layout. Layout switching:
 CapsLock to the first layout, Shift+CapsLock, to the last layout.
2. Use disk manual mode. Create partitions automatically.
3. Rename volume to `fullback`.
4. Set encryption in volume settings.

Reboot to USB drive again. Mount laptop SSD.

Open `etc/fstab`.

Add `noatime,nodiratime` to root partitions.

Move `/tmp` and `/var/tmp` to RAM:

```
vartmp /var/tmp tmpfs defaults,noatime,nodiratime 0 0
vartmp /tmp     tmpfs defaults,noatime,nodiratime 0 0
```

Clean `tmp` and `var/tmp` dirs.

Reboot to system. Set name to `Andrey Sitnik` and login `ai`.

Copy `Dev/environment` and open `Install.md` locally.
Start to copy `.Private` and `.mozilla` in background.

Set laptop name:

```sh
sudo hostnamectl set-hostname foxbat
```

Disable <kbd>PgUp</kbd> and <kbd>PgDn</kbd>
`usr/share/X11/xkb/symbols/pc`:

```
    key <PGUP> { [ Left ] };
    key <PGDN> { [ Right ] };
```

Disable `Blank screen`, `Automatic Suspend`, `Automatick Brightness`,
and `Dim Screen` in Power settings.


### System Update

Remove unnecessary packages:

```sh
sudo dnf remove cheese rhythmbox gnome-boxesd orca gnome-contacts samba-client gnome-getting-started-docs nautilus-sendto gnome-shell-extension-* libreoffice-* gnome-characters gnome-maps gnome-photos simple-scan virtualbox-guest-additions gedit gnome-boxes
```

Add RPM Fusion:

```sh
sudo dnf install --nogpgcheck http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
```

Install applications from Flatpak:

```sh
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub com.transmissionbt.Transmission org.telegram.desktop org.gimp.GIMP us.zoom.Zoom org.gnome.SoundRecorder com.yubico.yubioath org.freedesktop.Platform.ffmpeg-full/x86_64/19.08
```

Update system:

```sh
sudo dnf update --refresh
```

Install Chrome:

```sh
sudo dnf install fedora-workstation-repositories
sudo dnf config-manager --set-enabled google-chrome
sudo dnf install google-chrome-stable
```

Disable Software auto-start:

```sh
dconf write /org/gnome/software/allow-updates false
dconf write /org/gnome/software/download-updates false
mkdir -pv ~/.config/autostart && cp /etc/xdg/autostart/gnome-software-service.desktop ~/.config/autostart/
echo "X-GNOME-Autostart-enabled=false" >> ~/.config/autostart/gnome-software-service.desktop
dconf write /org/gnome/desktop/search-providers/disabled "['org.gnome.Software.desktop']"
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
2. Set `HandleLidSwitch=lock`

Restart.


### Text Editors

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

Install better diff can cat:

```sh
sudo dnf install git-delta bat
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

Change permissions:

```sh
chmod 744 ~/.ssh
chmod 700 ~/.gnupg/
chmod 644 ~/.ssh/* ~/.gnupg/*
chmod 700 ~/.gnupg/private-keys-v1.d
chmod 600 ~/.ssh/id_ed25519 ~/.gnupg/private-keys-v1.d/*
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
zsh
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

* **Notifictions:** disable Lock Screen Notifications.
* **Search:** keep only Calculator and Weather.
* **Background:** use standard GNOME wallpaper.
* **Online Accounts:** add Google account.
* **Mouse & Touchpad:** mouse speed to 75%,
 touchpad speed to 90%, enable Tap to Click.
* **Users:** set avatar and Automatic Login.
* **Power:** Show Battery Percentage.
* **Region & Language:** UK formats.

Set keyboard settings:

```sh
dconf write /org/gnome/desktop/input-sources/xkb-options "['grp_led:caps', 'lv3:ralt_switch', 'misc:typo', 'nbsp:level3', 'lv3:lsgt_switch', 'grp:shift_caps_switch']"
```

Terminal:

* **Unnamed Profile:** disable Terminal bell and disable scrollback limit.

Nautilus:

* **Views:** enable Sort folders before files.
* **Behaviour:** enable Single click to open items.

```sh
sudo dnf install lm_sensors
```

Install extensions from [`GNOME.md`](./GNOME.md).

* **Autohide battery:** use battery level from BIOS.
* **Freon:** move it to the right, hide `°C`, show only maximum value.
* **Emoji selector:** disable Always show the icon.
* **GSConnect:** add phone.
* **Icon Hider:** hide `appMenu`, `dwellClick`, `a11y`, `keyboard`, `GSConnect`.
* **Screenshot Tool:** disable Show Indicator, enable Auto-Save to Downloads
  with `{Y}{m}{d}{H}{M}{S}` name, enable Imgur Upload
  with Copy Link After Upload, set `Print` keyboard binding.
* **System monitor:** move to left, hide activity.

Add San Francisco, Moscow, Beijing, and Vladivostok in Clocks.

Install [JetBrains Mono](https://www.jetbrains.com/lp/mono/) font.

Install GNOME Tweaks:

```sh
sudo dnf install gnome-tweak-tool
```

* **General:** enable Over-Amplification.
* **Top Bar:** enable Date and Seconds.
* **Window Titlebars:** Double-Click: toggle maximize vertical,
 Middle-Click: toggle maximize.
* **Keyboard & Mouse:** enable Adaptive in Acceleration Profile.
* **Windows:** disable Edge Tiling.
* **Fonts:** monospace to JetBrains Mono.

Move applications from folders.


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
sudo dnf install amrnb amrwb faac faad2 flac gstreamer1-libav gstreamer1-plugins-bad-freeworld gstreamer-ffmpeg gstreamer-plugins-bad-nonfree gstreamer-plugins-espeak gstreamer-plugins-ugly lame libdca libmad libmatroska x264 x265 xvidcore gstreamer1-plugins-bad-free gstreamer1-plugins-base gstreamer1-plugins-good gstreamer-plugins-bad gstreamer1-plugins-ugly-free mpv xorg-x11-drv-intel intel-media-driver
```

Install tools:

```sh
sudo dnf install unrar p7zip p7zip-plugins
```

Install Microsoft fonts:

```sh
sudo dnf install https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm
```

Download [VPN client](https://mullvad.net/download/).

Left only Telegram, Firefox, Nautilus, and Terminal, VS Code, Yubico 2FA
in the dock.


### Development Tools

Install tools:

```sh
sudo dnf install git tig ripgrep exa make gcc-c++ zlib-devel
```

Install Node.js:

```sh
sudo dnf install nodejs
```

Install asdf:

```sh
git clone https://github.com/asdf-vm/asdf.git ~/.asdf
cd ~/.asdf
git checkout "$(git describe --abbrev=0 --tags)"
asdf plugin-add yarn
asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
~/Dev/environment/bin/copy-env system
```

Restart terminal:

```sh
asdf install nodejs latest
asdf install yarn latest
```

Sign-in to npm:

```sh
npm login
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
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

Fix [Docker bug](https://github.com/docker/for-linux/issues/665):

```sh
sudo dnf install grubby
sudo grubby --update-kernel=ALL --args="systemd.unified_cgroup_hierarchy=0"
sudo firewall-cmd --permanent --zone=trusted --add-interface=docker0
```

Install Keybase:

```sh
sudo dnf install https://prerelease.keybase.io/keybase_amd64.rpm
run_keybase
```

Remove Keybase from Autostart.
