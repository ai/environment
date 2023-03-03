## How I install my system

### Preparing

Download [Fedora image](https://getfedora.org/ru/workstation/)
and write it to the USB drive:

```sh
sudo dnf install mediawriter
```

Copy `.ssh` and `.gnupg` into `Private`.

Copy these files to external SDD:
* `Dev/environment`
* `.ssh`
* `Видео`


### BIOS

Boot to BIOS and set supervisor password.
Block changing boot without password.


### Install

Start installer.

1. Select Spanish language.
2. Add the US and Russian keyboard layouts. Layout switching:
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
deltarpm=false
fastestmirror=true
```

Disable NVIDIA, Flathub Selection, and PyCharm repositories in Software Center settings.

Disable `Blank screen`, `Automatic Suspend`, and `Dim Screen` in Power settings.

Copy `Dev/environment` and open `Install.md` locally.


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
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub io.github.TransmissionRemoteGtk org.telegram.desktop us.zoom.Zoom org.inkscape.Inkscape com.github.unrud.VideoDownloader vn.hoabinh.quan.CoBang md.obsidian.Obsidian
flatpak remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
flatpak install flathub-beta org.gimp.GIMP
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
echo "X-GNOME-Autostart-enabled=false" >> ~/.config/autostart/gnome-software-service.desktop
dconf write /org/gnome/desktop/search-providers/disabled "['org.gnome.Software.desktop']"
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
dnf copr enable atim/starship
sudo dnf install zsh util-linux-user starship
chsh -s /bin/zsh
```

Install Antigen:

```sh
curl -L git.io/antigen > ~/.antigen.zsh
zsh
source ~/.antigen.zsh
```

Create `/root/.zshrc`:

```sh
eval "$(starship init zsh)"
```

Reboot.

```sh
rm ~/.bash_history ~/.bash_logout
```

Install backup tool:

```sh
sudo dnf install borgbackup
```

Open backup and copy files from it.

```sh
cd /
export BORG_REPO=ai@susedko.local:/var/mnt/vault/ai/.backup
borg extract $BORG_REPO::$(borg list --short --last 1 $BORG_REPO)
```

Start copying `Видео` from HDD in the background.

Install `micro` and its plugins:

```sh
sudo dnf install xclip micro gnome-console
micro -plugin install editorconfig
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
* **Keyboard:** add hot key for screenshot.

Set keyboard settings:

```sh
dconf write /org/gnome/desktop/input-sources/xkb-options "['grp_led:caps', 'lv3:ralt_switch', 'misc:typo', 'nbsp:level3', 'lv3:lsgt_switch', 'grp:shift_caps_switch']"
```

Update typography keyboard layout:

```sh
sudo cp ~/Dev/environment/typo.txt /usr/share/X11/xkb/symbols/typo
```

Disable Terminal beep:

```sh
dconf write /org/gnome/desktop/sound/event-sounds "false"
```

Nautilus:

* Enable Sort folders before files.
* Enable Single click to open items.

Install `nautilus-code`:

```sh
sudo dnf install nautilus-devel meson
git clone --depth=1 https://github.com/realmazharhussain/nautilus-code.git
cd nautilus-code
meson setup build
meson install -C build
cd ..
rm -R nautilus-code
```

```sh
sudo dnf install gnome-extensions-app openssl
```

Install Microsoft fonts:

```sh
sudo dnf install https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm
```

Disable GNOME extension version check:

```
gsettings set org.gnome.shell disable-extension-version-validation true
```

Install extensions from [`GNOME.md`](./GNOME.md).

Set `.config/gnome-extensions.json` at Extensions Sync settings
and restore extension settings:

```sh
busctl --user call org.gnome.Shell /io/elhan/ExtensionsSync io.elhan.ExtensionsSync read
```

Add San Francisco, Moscow, Beijing, and Vladivostok in Clocks.

Install [Martians Mono](https://github.com/evilmartians/mono/releases) font.

Install GNOME Tweaks:

```sh
sudo dnf install gnome-tweak-tool
```

* **General:** enable Over-Amplification.
* **Top Bar:** enable Date and Seconds.
* **Keyboard & Mouse:** enable Adaptive in Acceleration Profile.
* **Windows:** enable window scaling with right mouse button.
* **Fonts:** monospace to `Martians Mono Nr Lt` and size `10`.

Move applications from folders.


### Folders

Create empty file template:

```sh
mkdir ~/.local/share/desktop
mkdir ~/.local/share/templates
touch ~/.local/share/templates/Archivo\ vacío
```

Fix folders at `~/.config/user-dirs.dirs`:

```sh
XDG_DESKTOP_DIR="$HOME/.local/share/desktop"
XDG_DOWNLOAD_DIR="$HOME/Descargas"
XDG_TEMPLATES_DIR="$HOME/.local/share/templates"
XDG_PUBLICSHARE_DIR="$HOME"
XDG_DOCUMENTS_DIR="$HOME"
XDG_MUSIC_DIR="$HOME"
XDG_PICTURES_DIR="$HOME"
XDG_VIDEOS_DIR="$HOME/Vídeos"
```

Clean bookmarks:

```sh
echo "" > ~/.config/gtk-3.0/bookmarks
```

Remove unnecessary folders:

```sh
rm -R ~/Documentos ~/Imágenes ~/Música ~/Público ~/Plantillas ~/Escritorio
```

Add icon theme:

```sh
sudo dnf copr enable dusansimic/themes
sudo dnf install morewaita-icon-theme
gsettings set org.gnome.desktop.interface icon-theme 'MoreWaita'
```

Set `/usr/share/icons/MoreWaita/places/scalables/folder-code.svg` icon
for `~/Dev/`.


### Additional Software

Install codecs:

```sh
sudo dnf install amrnb amrwb faac faad2 flac gstreamer1-libav gstreamer1-plugins-bad-freeworld gstreamer-ffmpeg gstreamer-plugins-bad-nonfree gstreamer-plugins-espeak gstreamer-plugins-ugly lame libdca libmad libmatroska x264 x265 xvidcore gstreamer1-plugins-bad-free gstreamer1-plugins-base gstreamer1-plugins-good gstreamer-plugins-bad gstreamer1-plugins-ugly-free mpv xorg-x11-drv-intel intel-media-driver webp-pixbuf-loader avif-pixbuf-loader
```

Install tools:

```sh
sudo dnf install unrar p7zip p7zip-plugins
```

Install Chrome:

```sh
sudo dnf install google-chrome-stable
```

Left only Telegram, Firefox, Nautilus, and Terminal in the dock.


### Development Tools

Install tools:

```sh
sudo dnf install git tig ripgrep exa xkill bat
```

Install tools for compile:

```sh
sudo dnf install make gcc-c++ gcc make bzip2 openssl-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel
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

Install Syncthing.

```sh
sudo dnf install syncthing
```

Add `Start Syncthing` to Autorun applications
(temporary remove `NoDisplay` from application icon).


## Language Server

Prepare [ngrams](https://languagetool.org/download/ngram-data/):

```sh
mkdir -p .local/share/ngrams
cd .local/share/ngrams
wget https://languagetool.org/download/ngram-data/ngrams-en-20150817.zip
wget https://languagetool.org/download/ngram-data/ngrams-es-20150915.zip
wget https://languagetool.org/download/ngram-data/untested/ngram-ru-20150914.zip
unzip ngrams-en-20150817.zip
unzip ngrams-es-20150915.zip
unzip ngram-ru-20150914.zip
rm ngram*.zip
wget https://languagetool.org/download/ngram-lang-detect/model_ml50_new.zip
```

Prepare `fasttext`:

```sh
sudo dnf install fasttext
mkdir -p .local/share/fasttext
cd .local/share/fasttext
wget https://dl.fbaipublicfiles.com/fasttext/supervised-models/lid.176.bin
```

Install Java:

```sh
sudo dnf install java-17-openjdk
```

Install LanguageTool:

```sh
wget https://languagetool.org/download/LanguageTool-stable.zip
unzip LanguageTool-stable.zip
rm LanguageTool-stable.zip
mkdir -p .local/lib/languagetool
mv LanguageTool-*/* .local/lib/languagetool
rm -R LanguageTool-*
```

Create config `.config/languagetool.properties`:

```
languageModel=/home/ai/.local/share/ngrams
fasttextModel=/home/ai/.local/share/fasttext/lid.176.bin
fasttextBinary=/usr/bin/fasttext
ngramLangIdentData=/home/ai/.local/share/ngrams/model_ml50_new.zi
```

Create service unit `~/.config/systemd/user/languagetool.service`:

```ini
[Unit]
Description=LanguageTool Server

[Service]
ExecStart=java -Xms512m -Xmx2g \
          -cp .local/lib/languagetool/languagetool-server.jar \
          org.languagetool.server.HTTPServer \
          --config .config/languagetool.properties \
          --port 8081 --allow-origin

[Install]
WantedBy=default.target
```

Enable service:

```sh
systemctl --user enable languagetool.service
```
