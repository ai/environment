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
rm -R ~/Dev/*/node_modules ~/Dev/*/*/node_modules ~/Dev/*/coverage ~/Dev/susedko/fedora-coreos.iso
```

Copy these files to external SDD:
* `Dev/`
* `Vídeos/*`
* `.Private/`


### BIOS

1. Boot to BIOS and set supervisor password.
3. Set Game Optimized iGPU.
4. Temporary enable USB boot.


### Install

Start installer:

1. Select English language.
2. Use entire disk mode with encryption.

Reboot to USB drive again. Mount laptop SSD.

Open `etc/fstab`.

Add `noatime,nodiratime` to root & home partitions.

Move `/tmp` and `/var/tmp` to RAM:

```
vartmp /var/tmp tmpfs defaults,noatime,nodiratime 0 0
vartmp /tmp     tmpfs defaults,noatime,nodiratime 0 0
```

Reboot to BIOS. Block boot from USB.

Reboot to system. Set Russian language, name to `Andrey Sitnik` and login `ai`.

Set laptop name:

```sh
sudo hostnamectl set-hostname savoia
```

Reboot.

Copy `Dev/` and `.Private/` from external SDD and open `Install.md` locally.

Reduce swap usage by creating `/etc/sysctl.d/99-swappiness.conf` with:

```
vm.swappiness = 10
```

Disable ambient light sensor:

```sh
echo "blacklist hid_sensor_hub" | sudo tee /etc/modprobe.d/blacklist.conf
sudo dracut --force
```

Fix booting video glitch:

```sh
sudo grubby --update-kernel=ALL --args="plymouth.use-simpledrm=0"
```

Enable `Rendimiento`, disable `Ahorro de energía automático`,
`Suspender automaticámente` in Energía settings.


### System Update

Set `KEYMAP=us` and `XKBLAYOUT=us` in `/etc/vconsole.conf`.

Remove unnecessary packages:

```sh
sudo dnf remove cheese rhythmbox gnome-boxesd orca gnome-contacts gnome-getting-started-docs nautilus-sendto gnome-shell-extension-* libreoffice-* gnome-characters gnome-maps gnome-photos simple-scan virtualbox-guest-additions gedit gnome-boxes gnome-tour gnome-connections mediawriter eog gnome-system-monitor baobab gnome-log gnome-calculator gnome-weather gnome-text-editor gnome-font-viewer gnome-clocks gnome-calendar evince totem ffmpeg-free snapshot intel-media-driver cups-browsed anaconda malcontent-control
```

Run Software Center, disable `Fedora Flatpak` and enable Flathub and Chrome.

Add RPM Fusion:

```sh
sudo dnf install --nogpgcheck http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
```

Update system via Software Center.

Install software:

```sh
sudo dnf swap ffmpeg-free ffmpeg --allowerasing
sudo dnf swap mesa-va-drivers mesa-va-drivers-freeworld
sudo dnf swap mesa-vdpau-drivers mesa-vdpau-drivers-freeworld
sudo dnf copr enable atim/starship
sudo dnf copr enable dusansimic/themes
sudo dnf copr enable hyperreal/better_fonts
sudo dnf install xclip micro fuse-encfs zenity borgbackup openssl ffmpegthumbnailer nss-tools mosquitto ydotool amrnb amrwb faac faad2 flac gstreamer1-libav gstreamer1-plugins-bad-freeworld gstreamer-ffmpeg gstreamer-plugins-bad-nonfree gstreamer-plugins-espeak gstreamer-plugins-ugly lame libdca libmad libmatroska x264 x265 xvidcore gstreamer1-plugins-bad-free gstreamer1-plugins-base gstreamer1-plugins-good gstreamer-plugins-bad gstreamer1-plugins-ugly-free mpv ffmpeg xorg-x11-drv-intel intel-media-driver webp-pixbuf-loader heif-pixbuf-loader avif-pixbuf-loader libheif-freeworld ffmpeg-libs libva libva-utils gstreamer1-vaapi mozilla-openh264 libheif-tools unrar p7zip p7zip-plugins speech-dispatcher speech-dispatcher-utils google-chrome-stable nodejs podman git tig ripgrep xkill bat make difftastic java-21-openjdk nextcloud-client zsh util-linux-user starship sqlite  morewaita-icon-theme nethogs fuse-sshfs logiops
sudo dnf install cabextract xorg-x11-font-utils
sudo rpm -ivh --nodigest --nofiledigest https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm
```

Set Flatpak languages:

```sh
flatpak config languages --set "es;en;ru"
sudo flatpak update
```

Install applications from Flatpak:

```sh
flatpak install flathub de.haeckerfelix.Fragments org.telegram.desktop us.zoom.Zoom org.nickvision.tubeconverter org.gnome.Loupe com.mattjakeman.ExtensionManager io.gitlab.adhami3310.Converter io.missioncenter.MissionCenter org.gnome.baobab org.gnome.Calculator org.gnome.Logs org.gnome.Weather org.gnome.clocks org.gnome.Calendar org.gnome.Epiphany org.inkscape.Inkscape org.gnome.gitlab.YaLTeR.VideoTrimmer org.gnome.World.Iotas app.devsuite.Ptyxis hu.irl.cameractrls org.gnome.Snapshot org.gnome.Papers org.gimp.GIMP dev.zed.Zed be.alexandervanhee.gradia com.github.PintaProject.Pinta com.yubico.yubioath
```

Remove default GNOME console.

Fix unnecessary folder creation in Zoom:

```sh
flatpak override --user us.zoom.Zoom --nofilesystem=~/Documents/Zoom
mkdir -p ~/.local/share/flatpak/exports/share/applications/
cp /var/lib/flatpak/exports/share/applications/us.zoom.Zoom.desktop ~/.local/share/flatpak/exports/share/applications/
```

Replace `Exec` to `/home/ai/Dev/environment/bin/zoom @@u %U @@` in `~/.local/share/flatpak/exports/share/applications/us.zoom.Zoom.desktop`.

Add Autostart and fingers to user settings.

Disable Software auto-update and notifications.

Set [color profile](https://www.notebookcheck.net/uploads/tx_nbc2/BOE0CB4.icm)
in `Color` settings.

Install `micro` and its plugins:

```sh
micro -plugin install editorconfig
sudo dnf remove nano
```

Disable waking up by mouse by creating `/etc/udev/rules.d/logitech-bolt.rules`:

```sh
ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c548", ATTR{power/wakeup}="disabled"
```

Disable file system scanning:

```sh
dconf write /org/freedesktop/tracker/miner/files/crawling-interval -2
```


### Personal Files

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
chmod 600 ~/.ssh/id_* ~/.gnupg/private-keys-v1.d/*
```

Copy configs:

```sh
~/Dev/environment/bin/copy-env system
```


## Input

Set mouse buttons config at `/etc/logid.cfg`:

```
devices: ({
  name: "MX Master 3S";

  smartshift: { on: false; }

  hiresscroll: { hires: false; invert: false; target: false; };

  buttons: (
    {
      cid: 0x53;  # Back
      action = {
        type: "Keypress";
        keys: ["KEY_LEFTCTRL", "KEY_V"];
      };
    },
    {
      cid: 0x56;  # Forward
      action = {
        type: "Keypress";
        keys: ["KEY_LEFTCTRL", "KEY_C"];
      };
    }
  );
});
```

Add `-c /etc/logid.cfg` to `Exec` field of `/usr/lib/systemd/system/logid.service`.

Enable mouse extensions:

```sh
sudo systemctl enable --now logid
```

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


### Terminal

Install eza:

```sh
curl -sL https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz | tar xz
chmod +x eza
mkdir -p ~/.local/bin/
mv eza ~/.local/bin
```

Install atuin:

```sh
curl -sL https://github.com/atuinsh/atuin/releases/download/v18.6.1/atuin-x86_64-unknown-linux-gnu.tar.gz | tar xz --strip-components=1 atuin-x86_64-unknown-linux-gnu/atuin
mv atuin ~/.local/bin
```

Install zsh:

```sh
mkdir -p ~/.local/share/history
chmod 700 ~/.local/share/history
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.local/lib/zsh/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.local/lib/zsh/zsh-autosuggestions
git clone https://github.com/jimhester/per-directory-history ~/.local/lib/zsh/per-directory-history
chsh -s /bin/zsh
```

Create `/root/.zshrc`:

```sh
eval "$(starship init zsh)"
```

Reboot.

Select `Russian Universal` and `English/Spanish/Catalan Universal` layouts.

```sh
rm ~/.bash*
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

Start copying `Vídeos/*` from SDD.


### Text Editors

Sign-in into accounts in Zed.

Install Zed plugins: `ini`, `dockerfile`, `toml`, `svelte`, `make`, `adwaita`, `material icon theme`, `codebook`, `sql`, `nginx`, `git-firefly`, `pug`, `xml`, `po`, `env`, `stylelint`.

Open Iotas app, log-in into Nextcloud account.


### GNOME Settings

Open Clock and add `Vladivostok`, `Moscow`, `Lisbon`, and `San Francisco`.

Run Weather app and set current location.

Install [JetBrains Mono](https://www.jetbrains.com/lp/mono/).

```sh
mkdir -p ~/.local/share/fonts
# Copy variable fonts
fc-cache -f -v
gsettings set org.gnome.desktop.interface monospace-font-name "JetBrains Mono Regular 12"
```

Open settings:

* **Apariencia:** use standard GNOME wallpaper.
* **Notificaciones:** disable Notificaciones de la pantalla de bloqueo.
* **Buscar:** keep only Calculadora and Configuracion.
* **Multitarea:** disable Activar bordes de la pantalla.
* **Cuentas en línea:** add Google.
* **Energía:** enable Mostrar porcentaje de la bataría.
* **Ratón y panel táctil:** mouse speed to 75%, touchpad speed to 90%.
* **Sistema** → **Fecha y hora:** enable seconds and week day on top panel.
* **Privacidad y seguridad** → **Historico de archivos y papelera**: disable File History.

Login to NextCloud client to `sync.sitnik.ru`.

Nautilus:

* Enable Sort folders before files.
* Enable Single click to open items.
* Enable preview, search, file numbers for remote folders.

Disable GNOME extension version check:

```sh
gsettings set org.gnome.shell disable-extension-version-validation true
```

Download the latest [`framework_tool`](https://github.com/FrameworkComputer/framework-system/actions?query=branch%3Amain), extract and copy to the system:

```sh
sudo cp ~/Descargas/framework_tool /usr/local/bin
```

Install extensions from [`GNOME.md`](./GNOME.md).

Restore settings file from backup:

```sh
~/Dev/environment/bin/restore-gnome-extensions
```

Clean up applications list.

Add Iceland NordVPN.

[Disable](https://discussion.fedoraproject.org/t/please-enter-passphrase-for-disk-has-returned/150626/5) disk name in password prompt.


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
XDG_PUBLICSHARE_DIR="$HOME/.local/share/desktop"
XDG_DOCUMENTS_DIR="$HOME/Documentos"
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
rm -R ~/Imágenes ~/Música ~/Público ~/Plantillas ~/Escritorio
mkdir "Capturas de pantalla"
```

Connect to server in Files by `sftp://ai@susedko.local/` and add `vault` to Favorites places. Add `Descargas` and `Capturas de pantalla` to Favorites places.

Left only Telegram, Firefox, Nautilus, Terminal, Iotas, System Update, and
Backup in the dock.

Add icon theme:

```sh
gsettings set org.gnome.desktop.interface icon-theme 'MoreWaita'
```

Set icons:

* `/usr/share/icons/MoreWaita/scalable/places/folder-code.svg`
  for `~/Dev/`.
* `/usr/share/icons/Adwaita/scalable/places/folder-pictures.svg`
  for `~/Capturas de pantalla/`.


## Home Server

Add server’s certificate to the system:

```sh
mkdir -p ~/.pki/nssdb
certutil -N -d sql:$HOME/.pki/nssdb --empty-password
certutil -d sql:$HOME/.pki/nssdb -A -t "C,," -n sitnik -i ~/Dev/susedko/sitniks.crt
sudo cp ~/Dev/susedko/sitniks.crt /etc/pki/ca-trust/source/anchors/sitniks.pem
sudo update-ca-trust
```

Add service to `~/.config/systemd/user/susedko-listener.service`:

```ini
[Unit]
Description=Susedko Listener
After=network-online.target
Wants=network-online.target

[Service]
ExecStart=/home/ai/Dev/environment/bin/susedko-listener
Restart=on-failure
RestartSec=30s
StartLimitBurst=5

[Install]
WantedBy=default.target
```

Add service to `/etc/systemd/system/ydotoold.service`:

```ini
[Unit]
Description=ydotool Daemon

[Service]
ExecStart=ydotoold --socket-path="/run/.ydotool_socket" --socket-own="1000:1000"
Restart=on-failure
RestartSec=30s

[Install]
WantedBy=default.target
```

Enable services:

```sh
sudo systemctl enable ydotoold.service
sudo systemctl start ydotoold.service
systemctl --user enable susedko-listener.service
systemctl --user start susedko-listener.service
```


### Development Tools

Install Node.js, TypeScript, and Dev Containers.

```sh
mkdir -p ~/.local/lib/node/
tee -a ~/.local/lib/node/package.json << EOM
{
  "dependencies": {
    "@devcontainers/cli": ">=0.76.0"
  }
}
EOM
cd ~/.local/lib/node && npm install && cd

mkdir -p ~/.local/share/multiocular
mkdir -p ~/.local/share/history
chmod 700 ~/.local/share/history
podman volume create shell-history
podman volume create pnpm-store

~/Dev/environment/bin/build-devcontainer
cd ~/Dev/nanostores
devup
# Find container ID
podman exec -it --user root $container_id zsh
mkdir /home/ai/.local/share/pnpm/store/v10
chown ai:ai /home/ai/.local/share/pnpm/store/v10
chown ai:ai /home/ai/.local/share/history/histfile
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

Disable autostart in Keybase settings and revoke old laptop.


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
wget https://download.copr.fedorainfracloud.org/results/fcsm/fasttext/fedora-42-x86_64/08912218-fasttext/fasttext-0.9.2-5.fc42.x86_64.rpm https://download.copr.fedorainfracloud.org/results/fcsm/fasttext/fedora-42-x86_64/08912218-fasttext/fasttext-libs-0.9.2-5.fc42.x86_64.rpm
sudo dnf install ./fasttext-*
rm ./fasttext-*
mkdir -p ~/.local/share/fasttext
cd ~/.local/share/fasttext
wget https://dl.fbaipublicfiles.com/fasttext/supervised-models/lid.176.bin
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

Install LanguageTool:

```sh
~/Dev/environment/bin/update-languagetool
```

Enable service.

```sh
systemctl --user enable --now languagetool.service
systemctl --user start --now languagetool.service
```


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
gcloud auth login
```
