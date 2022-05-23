## How I install my system

### Preparing

Download [Fedora image](https://getfedora.org/ru/workstation/)
and write it to the USB drive:

```sh
sudo dnf install mediawriter
```

Copy `.ssh` and `.gnupg` into `Private`.

Copy these files to external SDD:
* `Dev/`
* `.Private/`
* `.mozilla/firefox`
* `Видео/`


### BIOS

Boot to BIOS and set supervisor password.
Block changing boot without password.


### Install

Start installer.

1. Select English (US) language.
2. Add the Russian keyboard layout. Layout switching:
 CapsLock to the first layout, Shift+CapsLock, to the last layout.
3. Use disk manual mode. Create partitions automatically.
4. Rename volume to `fullback`.
5. Set encryption in volume settings.

Reboot to USB drive again. Mount laptop SSD.

Open `etc/fstab`.

Add `noatime,nodiratime` to root partitions.

Move `/tmp` and `/var/tmp` to RAM:

```
vartmp /var/tmp tmpfs defaults,noatime,nodiratime 0 0
vartmp /tmp     tmpfs defaults,noatime,nodiratime 0 0
```

Clean `tmp` and `var/tmp` dirs.

Reboot to system. Set name to `Андрей Ситник` and login `ai`.

Change language and format rules to Russians.

Set laptop name:

```sh
sudo hostnamectl set-hostname fullback
```

Clean Windows EFI record:

```sh
sudo efibootmgr
sudo efibootmgr -B 0
```

Reboot.

Speed-up DNF by running `sudo nano /etc/dnf/dnf.conf` and adding:

```
fastestmirror=true
```

Disable NVIDIA, Flathub Selection, and PyCharm repositories in Software Center settings.

Install `micro` and its plugins:

```sh
sudo dnf install xclip micro gnome-console
micro -plugin install editorconfig
```

Copy `Dev/environment` and open `Install.md` locally.
Start to copy `.Private` and `.mozilla` in background.

Disable `Blank screen`, `Automatic Suspend`, and `Dim Screen` in Power settings.


### System Update

Remove unnecessary packages:

```sh
sudo dnf remove cheese rhythmbox gnome-boxesd orca gnome-contacts gnome-getting-started-docs nautilus-sendto gnome-shell-extension-* libreoffice-* gnome-characters gnome-maps gnome-photos simple-scan virtualbox-guest-additions gedit gnome-boxes gnome-tour gnome-connections mediawriter yelp podman gnome-terminal
```

Add RPM Fusion:

```sh
sudo dnf install --nogpgcheck http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
```

Install applications from Flatpak:

```sh
flatpak remote-add flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub com.transmissionbt.Transmission org.telegram.desktop org.gimp.GIMP us.zoom.Zoom org.inkscape.Inkscape
```

Update system via Software Center.

Install 2FA app:

```sh
sudo dnf install yubioath-desktop
```

Disable Software auto-start:

```sh
dconf write /org/gnome/software/allow-updates false
dconf write /org/gnome/software/download-updates false
mkdir -pv ~/.config/autostart && cp /etc/xdg/autostart/org.gnome.Software.desktop ~/.config/autostart/
echo "X-GNOME-Autostart-enabled=false" >> ~/.config/autostart/org.gnome.Software.desktop
```


### Base Settings

Enable HiDPI in TTY:

```sh
sudo dnf install terminus-fonts-console terminus-fonts-grub2
```

Add to `/etc/vconsole.conf`:

```
KEYMAP="us"
FONT="ter-v32n"
```

Copy font:

```sh
sudo mkdir -p /boot/efi/EFI/fedora/fonts/
sudo cp /usr/share/grub/ter-u32n.pf2 /boot/efi/EFI/fedora/fonts/
```

Add to `/etc/default/grub`:

```
GRUB_TIMEOUT=0
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

1. `sudo micro /etc/systemd/logind.conf`
2. Set `HandleLidSwitch=lock`


### Personal Files

Copy configs:

```sh
~/Dev/environment/bin/copy-env system
```

Install encryption tools:

```sh
sudo dnf install fuse-encfs
```

Open Private files and copy `.ssh/` and `.gnupg/`.

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

```sh
rm ~/.bash_history ~/.bash_logout
```


### Text Editors

Remove `nano`:

```sh
sudo dnf remove nano
```

Install VS Code:

```sh
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo dnf install code git-delta
```

Add to `/etc/sysctl.conf`:

```
fs.inotify.max_user_watches=524288
```

Install [VS Code extensions](./VSCode.md).


### GNOME Settings

Open settings:

* **Background:** use standard GNOME wallpaper.
* **Notifictions:** disable Lock Screen Notifications.
* **Search:** keep only Calculator.
* **Multitasking:** disable Active Screen Edges.
* **Online Accounts:** add Google account.
* **Power:** Show Battery Percentage.
* **Mouse & Touchpad:** mouse speed to 75%, touchpad speed to 90%,
  enable Tap to Click.
* **Users:** set fingerprint, avatar and Automatic Login.

Set keyboard settings:

```sh
dconf write /org/gnome/desktop/input-sources/xkb-options "['grp_led:caps', 'lv3:ralt_switch', 'misc:typo', 'nbsp:level3', 'lv3:lsgt_switch', 'grp:shift_caps_switch']"
```

Update typography keyboard layout:

```sh
sudo cp ~/Dev/environment/typo.txt /usr/share/X11/xkb/symbols/typo
```

Terminal:

* **Unnamed Profile:** disable Terminal bell and disable scrollback limit.

Nautilus:

* Enable Sort folders before files.
* Enable Single click to open items.

```sh
sudo dnf install gnome-extensions-app openssl
```

Install Microsoft fonts:

```sh
sudo dnf install https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm
```

Disable GNOME extenstion version check:

```
gsettings set org.gnome.shell disable-extension-version-validation true
```

Install extensions from [`GNOME.md`](./GNOME.md).

* **Autohide battery:** use battery level from Thinkpad Battery Threshold.
* **Emoji selector:** disable Always show the icon.
* **GSConnect:** add phone.
* **Thinkpad Battery Threshold:** 75 and 80%.

Add San Francisco, Moscow, Beijing, and Vladivostok in Clocks.

Install [JetBrains Mono](https://www.jetbrains.com/lp/mono/) font.

Install GNOME Tweaks:

```sh
sudo dnf install gnome-tweak-tool
```

* **General:** enable Over-Amplification.
* **Top Bar:** enable Date and Seconds.
* **Keyboard & Mouse:** enable Adaptive in Acceleration Profile.
* **Windows:** enable window scaling with right mouse button.
* **Fonts:** monospace to JetBrains Mono.

Move applications from folders.


### Folders

Create empty file template:

```sh
mkdir ~/.local/share/desktop
mkdir ~/.local/share/templates
touch ~/.local/share/templates/Пустой\ файл
```

Fix folders at `~/.config/user-dirs.dirs`:

```sh
XDG_DESKTOP_DIR="$HOME/.local/share/desktop"
XDG_DOWNLOAD_DIR="$HOME/Загрузки"
XDG_TEMPLATES_DIR="$HOME/.local/share/templates"
XDG_PUBLICSHARE_DIR="$HOME"
XDG_DOCUMENTS_DIR="$HOME"
XDG_MUSIC_DIR="$HOME"
XDG_PICTURES_DIR="$HOME"
XDG_VIDEOS_DIR="$HOME/Видео"
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
sudo dnf install amrnb amrwb faac faad2 flac gstreamer1-libav gstreamer1-plugins-bad-freeworld gstreamer-ffmpeg gstreamer-plugins-bad-nonfree gstreamer-plugins-espeak gstreamer-plugins-ugly lame libdca libmad libmatroska x264 x265 xvidcore gstreamer1-plugins-bad-free gstreamer1-plugins-base gstreamer1-plugins-good gstreamer-plugins-bad gstreamer1-plugins-ugly-free mpv xorg-x11-drv-intel intel-media-driver webp-pixbuf-loader
```

Install tools:

```sh
sudo dnf install unrar p7zip p7zip-plugins
```

Install Chrome:

```sh
sudo dnf install google-chrome-stable
```

Download [VPN client](https://mullvad.net/download/).

Left only Telegram, Firefox, Nautilus, and Terminal, VS Code, Yubico 2FA
in the dock.


### Development Tools

Install tools:

```sh
sudo dnf install git tig ripgrep exa xkill bat
```

Install tools for compile:

```sh
dnf install -y make gcc-c++ gcc make bzip2 openssl-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel
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
```

Restart terminal:

```sh
asdf plugin-add yarn
asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf plugin-add pnpm https://github.com/jonathanmorley/asdf-pnpm.git
asdf install
```

Sign-in to npm:

```sh
npm login
```

Install Keybase:

```sh
sudo dnf install https://prerelease.keybase.io/keybase_amd64.rpm
run_keybase
```

Disable autostart in Keybase settings.

Edit file `/var/lib/flatpak/app/us.zoom.Zoom/x86_64/stable/active/metadata`
and change `~/Documents/Zoom` to `~/.Documents/Zoom`.

Open Zoom and sign-in into corporate account.
