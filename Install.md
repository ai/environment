## How I install my system

### Preparing

Download [Fedora image](https://getfedora.org/ru/workstation/)
and write it to the USB drive:

```sh
flatpak install flathub io.gitlab.adhami3310.Impression
```

Copy `.ssh` and `.gnupg` into `.Private`.

Clean `node_modules`:

```sh
rm -R ~/Dev/*/node_modules ~/Dev/*/*/node_modules ~/Dev/*/coverage ~/Dev/*/*/coverage ~/Dev/susedko/fedora-coreos.iso
```

Copy these files to external SDD:
* `Dev/`
* `Vídeos/Juntos/`
* `.Private/`
* `/etc/opensnitchd/rules`


### BIOS

Boot to BIOS and set supervisor password.

Set battery charge limit to 80%.


### Install

Start installer:

1. Select Spanish language.
2. Set the only US keyboard layouts.
3. Use disk manual mode.
   1. Create `btrfs` partitions automatically.
   2. Remove `/home` partition.
   3. Remove `/` partition.
   4. Add new `/` partition.
   5. Rename volume to `savoia`.
   6. Set encryption in volume settings.

Reboot to USB drive again. Mount laptop SSD.

Open `etc/fstab`.

Add `noatime,nodiratime` to root partitions.

Move `/tmp` and `/var/tmp` to RAM:

```
vartmp /var/tmp tmpfs defaults,noatime,nodiratime 0 0
vartmp /tmp     tmpfs defaults,noatime,nodiratime 0 0
```

Reboot to BIOS. Block boot from USB.

Reboot to system. Set name to `Andrey Sitnik` and login `ai`.

Set laptop name:

```sh
sudo hostnamectl set-hostname savoia
```

Change boot method:

```sh
sudo dnf install virt-firmware uki-direct
sudo sh /usr/share/doc/python3-virt-firmware/experimental/fixup-partitions-for-uki.sh
sudo dnf install kernel-uki-virt
```

Reboot.

Copy `Dev/` and `.Private` from external SDD and open `Install.md` locally.

Reduce swap usage by creating `/etc/sysctl.d/99-swappiness.conf` with:

```
vm.swappiness = 10
```

Fix video driver:

```sh
sudo grubby --update-kernel=ALL --args="amdgpu.sg_display=0"
```

Speed-up DNF by running `sudo nano /etc/dnf/dnf.conf` and adding:

```
fastestmirror=true
```

Enable `Rendimiento`, set `Apagar la pantalla` at `10 minutos`,
disable `Ahorro de energía automático`, `Suspender automaticámente`,
and `Oscurecer la patalla` in Energía settings.


### System Update

Remove unnecessary packages:

```sh
sudo dnf remove cheese rhythmbox gnome-boxesd orca gnome-contacts gnome-getting-started-docs nautilus-sendto gnome-shell-extension-* libreoffice-* gnome-characters gnome-maps gnome-photos simple-scan virtualbox-guest-additions gedit gnome-boxes gnome-tour gnome-connections mediawriter podman eog gnome-system-monitor baobab gnome-log gnome-calculator gnome-weather gnome-text-editor gnome-font-viewer gnome-clocks gnome-calendar evince totem ffmpeg-free snapshot
```

Run Software Center, disable `Fedora Flatpak` and enable Flathub and Chrome.

Add RPM Fusion:

```sh
sudo dnf install --nogpgcheck http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
```

Install applications from Flatpak:

```sh
flatpak install flathub de.haeckerfelix.Fragments org.telegram.desktop us.zoom.Zoom org.nickvision.tubeconverter com.belmoussaoui.Decoder md.obsidian.Obsidian org.gnome.Loupe com.yubico.yubioath com.mattjakeman.ExtensionManager io.gitlab.adhami3310.Converter io.missioncenter.MissionCenter org.gnome.baobab org.gnome.Calculator org.gnome.Logs org.gnome.Weather org.gnome.TextEditor org.gnome.clocks org.gnome.Calendar org.gnome.Epiphany org.inkscape.Inkscape org.gnome.Evince org.gnome.gitlab.YaLTeR.VideoTrimmer
flatpak remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
flatpak install flathub-beta org.gimp.GIMP
```

Fix unnecessary dir creation in Zoom:

```sh
flatpak override --user us.zoom.Zoom --nofilesystem=~/Documents/Zoom
```

Update system via Software Center.

Add Autostart and fingers to user settings.

Disable Software auto-start:

```sh
dconf write /org/gnome/software/allow-updates false
dconf write /org/gnome/software/download-updates false
mkdir -pv ~/.config/autostart && cp /etc/xdg/autostart/org.gnome.Software.desktop ~/.config/autostart/
echo "X-GNOME-Autostart-enabled=false" >> ~/.config/autostart/gnome-software-service.desktop
dconf write /org/gnome/desktop/search-providers/disabled "['org.gnome.Software.desktop']"
echo "X-GNOME-Autostart-enabled=false" >> ~/.config/autostart/org.gnome.Software.desktop
```

Install new Terminal:

```sh
sudo dnf install gnome-console
```

Change terminal and uninstall old:

```sh
sudo dnf remove gnome-terminal
```

Enable mouse buttons presets:

```sh
sudo dnf install input-remapper
sudo systemctl enable --now input-remapper
```

Set [color profile](https://www.notebookcheck.net/uploads/tx_nbc2/BOE_CQ_______NE135FBM_N41_03.icm)
in `Settings` → `Color`.

Install `micro` and its plugins:

```sh
sudo dnf install xclip micro
micro -plugin install editorconfig
sudo dnf remove nano
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

Enable HiPDI on login screen:

```sh
sudo cp ~/.config/monitors.xml /var/lib/gdm/.config/
sudo chown gdm:gdm /var/lib/gdm/.config/monitors.xml
```


### Personal Files

Copy configs:

```sh
~/Dev/environment/bin/copy-env system
```

Install encryption tools:

```sh
sudo dnf install fuse-encfs zenity
```

Copy `.ssh` and `.gnupg`:

```sh
~/Dev/environment/bin/private
```

Change permissions:

```sh
chmod 744 ~/.ssh
chmod 700 ~/.gnupg/
chmod 644 ~/.ssh/* ~/.gnupg/*
chmod 700 ~/.gnupg/private-keys-v1.d
chmod 600 ~/.ssh/id_ed25519 ~/.gnupg/private-keys-v1.d/*
```

Add to `~/.ssh/config`:

```
Host github.com
   HostName github.com
   IdentityFile ~/.ssh/id_ed25519_sk
   IdentitiesOnly yes
```


### Terminal

Install zsh:

```sh
sudo dnf copr enable atim/starship
sudo dnf install zsh util-linux-user starship sqlite
chsh -s /bin/zsh
```

Install Antigen:

```sh
curl -L git.io/antigen > ~/.antigen.zsh
zsh
```

Create `/root/.zshrc`:

```sh
eval "$(starship init zsh)"
```

Reboot.

```sh
rm ~/.bash*
```

Install backup tool:

```sh
sudo dnf install borgbackup
```

Open backup and copy files from it.

```sh
mkdir ~/backup
borg mount "ai@susedko.local:/var/mnt/vault/ai/backup" ~/backup
```

Copy files.

```sh
borg umount ~/backup
rmdir ~/backup
```

Connect to server in Files by `sftp://ai@susedko.local/`
and start copying `Vídeos/Erótica` from server in the background.

Add `vault` to Favorites places.


### Text Editors

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

Open Clock and add `Vladivostok`, `Beijing`, `Moscow`, `Lisbon`,
and `San Francisco`.

Run Weather app and set current location.

Install [JetBrains Mono](https://www.jetbrains.com/lp/mono/) font.

```sh
mkdir ~/.local/share/fonts
# Copy variable fonts
fc-cache -f -v
gsettings set org.gnome.desktop.interface monospace-font-name "JetBrains Mono Regular 12"
```

Open settings:

* **Appearance:** use standard GNOME wallpaper.
* **Notifictions:** disable Lock Screen Notifications.
* **Search:** keep only Calculator.
* **Multitasking:** disable Active Screen Edges.
* **Online Accounts:** add Google account.
* **Power:** Show Battery Percentage.
* **Mouse & Touchpad:** mouse speed to 75%, touchpad speed to 90%,
  enable Tap to Click.
* **Users:** set photo.
* **Date and time:** enable seconds and week day on top panel.

Install custom universal keyboard layouts:

```sh
mkdir -p ~/.config/xkb/symbols/ ~/.config/xkb/rules/
wget -O ~/.config/xkb/symbols/universal_en https://raw.githubusercontent.com/ai/universal-layout/main/universal_en.xkb
wget -O ~/.config/xkb/symbols/universal_ru https://raw.githubusercontent.com/ai/universal-layout/main/universal_ru.xkb
wget -O ~/.config/xkb/rules/evdev.xml https://raw.githubusercontent.com/ai/universal-layout/main/evdev.xml
```

Set keyboard settings:

```sh
dconf write /org/gnome/desktop/input-sources/xkb-options "['grp_led:caps', 'lv3:ralt_switch', 'grp:shift_caps_switch']"
```

Nautilus:

* Enable Sort folders before files.
* Enable Single click to open items.

```sh
sudo dnf install openssl
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

Clean up applications list.


### Folders

Install tools for thumbnails:

```sh
sudo dnf install gstreamer1-plugins-good-gtk gstreamer1-plugin-openh264 totem-video-thumbnailer
```

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

Set icons:

* `/usr/share/icons/MoreWaita/places/scalables/folder-code.svg`
  for `~/Dev/`.
* `/usr/share/icons/Adwaita/scalable/places/folder-pictures.svg`
  for `~/Capturas de pantalla/`.


## Home Server

Add server’s sertificate to the system:

```sh
sudo dnf install nss-tools
certutil -d sql:$HOME/.pki/nssdb -A -t "C,," -n sitnik -i ~/Dev/susedko/sitniks.crt
sudo cp sitniks.crt /etc/pki/ca-trust/source/anchors/sitniks.pem
sudo update-ca-trust
```


### Additional Software

Install codecs:

```sh
sudo dnf config-manager --set-enabled fedora-cisco-openh264
sudo dnf swap ffmpeg-free ffmpeg --allowerasing
sudo dnf install amrnb amrwb faac faad2 flac gstreamer1-libav gstreamer1-plugins-bad-freeworld gstreamer-ffmpeg gstreamer-plugins-bad-nonfree gstreamer-plugins-espeak gstreamer-plugins-ugly lame libdca libmad libmatroska x264 x265 xvidcore gstreamer1-plugins-bad-free gstreamer1-plugins-base gstreamer1-plugins-good gstreamer-plugins-bad gstreamer1-plugins-ugly-free mpv ffmpeg xorg-x11-drv-intel intel-media-driver webp-pixbuf-loader avif-pixbuf-loader ffmpeg-libs libva libva-utils gstreamer1-vaapi mozilla-openh264 libheif-tools
sudo dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
```

Install tools:

```sh
sudo dnf install unrar p7zip p7zip-plugins speech-dispatcher speech-dispatcher-utils
```

Install Chrome:

```sh
sudo dnf install google-chrome-stable
```

Fix Wayland in Chrome:
1. Open Chrome.
2. Open `chrome://flags/#ozone-platform-hint`.
3. Set Wayland.

Left only Telegram, Firefox, Nautilus, and Terminal in the dock.

Download and install [OpenShitch](https://github.com/evilsocket/opensnitch/releases).


### Development Tools

Install tools:

```sh
sudo dnf install git tig ripgrep eza xkill bat
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

And disable `postinstall` scripts for better security:

```sh
npm config set ignore-scripts true
```

Install Keybase:

```sh
sudo dnf install https://prerelease.keybase.io/keybase_amd64.rpm
run_keybase
```

Disable autostart in Keybase settings.

Open Zoom and sign-in into corporate account.


## LanguageTool Server

Prepare [ngrams](https://languagetool.org/download/ngram-data/):

```sh
mkdir -p ~/.local/share/ngrams
cd ~/.local/share/ngrams
wget https://languagetool.org/download/ngram-data/ngrams-en-20150817.zip
wget https://languagetool.org/download/ngram-data/ngrams-es-20150915.zip
wget https://languagetool.org/download/ngram-data/untested/ngram-ru-20150914.zip
unzip ngrams-en-20150817.zip
unzip ngrams-es-20150915.zip
unzip ngram-ru-20150914.zip
rm ngram*.zip
```

Prepare `fasttext`:

```sh
sudo dnf copr enable fcsm/fasttext
sudo dnf install fasttext
mkdir -p ~/.local/share/fasttext
cd ~/.local/share/fasttext
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
mkdir -p ~/.local/lib/languagetool
mv LanguageTool-*/* ~/.local/lib/languagetool
rm -R LanguageTool-*
```

Create config `~/.config/languagetool.properties`:

```ini
languageModel=/home/ai/.local/share/ngrams
fasttextModel=/home/ai/.local/share/fasttext/lid.176.bin
fasttextBinary=/usr/bin/fasttext
```

```sh
mkdir -p ~/.config/systemd/user/
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

Enable service.

```sh
systemctl --user enable --now languagetool.service
```

Open Obsidian app, trust the plugins, and log-in into Sync account.


## Google Cloud

Install `gcloud` CLI:

```sh
sudo tee -a /etc/yum.repos.d/google-cloud-sdk.repo << EOM
[google-cloud-cli]
name=Google Cloud CLI
baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el9-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=0
gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOM
sudo dnf install google-cloud-cli
```

Create a user for Google Cloud:

```sh
sudo useradd gcloud
```

Sign-in:

```sh
gcloud login
```
