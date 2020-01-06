## Как я ставлю свою систему

### Подготовка

Скачиваем образ [Fedora](https://getfedora.org/ru/workstation/).
Записываем его на USB-флешку:

```sh
sudo dnf install mediawriter
```

Записываем бэкап на внешний диск:

```sh
~/environment/backup
```


### Установка

Загружаемся с USB-флешки. На экране GRUB нажимаем <kbd>e</kbd> и дописываем
`modprobe.blacklist=intel_lpss_pci` в строку запуска.

Запускаем установщик.

1. Добавляем русскую раскладку. Переключение раскладок:
   «CapsLock (на первую раскладку), Shift+CapsLock (на последнюю раскладку)».
2. В ручном разбиение диска выбираем автоматически создать разделы.
3. Переименовываем том в `foxbat`.
4. В томе выбрать ширфование.
5. Удаляем `root` и `home`.
6. Создаём `root` снова на весь размер.

Перезагружаемся ещё раз в Live-USB. Подключаем диски установленной системы.

Открываем `etc/fstab`.

Добавляем опцию `noatime` для корневой системы.

Переносим `/tmp` и `/var/tmp` в оперативную память:

```
vartmp /var/tmp  tmpfs defaults,noatime  0  0
vartmp /tmp      tmpfs defaults,noatime  0  0
```

Чистим каталоги `tmp` и `var/tmp`.

Перезагружаемся в систему. Указываем имя по английски и логин `ai`.

Скопировать `Dev/environment` и локально открыть `Install.md`.
Поставить на копирование `.Private` и `.mozilla`.

Указываем имя ноутбуку:

```sh
sudo hostnamectl set-hostname foxbat
```

Включаем TRIM:

```sh
sudo systemctl enable fstrim.timer
```

Уменьшаем использование свапа в `/etc/sysctl.d/99-swappiness.conf`:

```
vm.swappiness=1
```

Меняем клавиши-стрелки `sudo nano /usr/share/X11/xkb/symbols/pc` и заменяем:

```
    key <PGUP> {        [  Left                 ]	};
    key <PGDN> {        [  Right                ]	};
```

Выключаем оптимизации батарейки в Tunables:

```sh
sudo dnf install powertop
sudo powertop
```

Ставим [ядро 5.4](https://koji.fedoraproject.org/koji/builds?prefix=k&order=-build_id) и чиним WiFi:

```
git clone https://chromium.googlesource.com/chromiumos/third_party/linux-firmware chromiumos-linux-firmware --depth=1
cd chromiumos-linux-firmware/
sudo cp iwlwifi-*  /lib/firmware/
cd /lib/firmware
sudo ln -s iwlwifi-Qu-c0-hr-b0-50.ucode iwlwifi-Qu-b0-hr-b0-50.ucode
```

Выключаем засыпания в настройках питания.


### Обновление системы

Удаляем ненужные пакеты:

```sh
sudo dnf remove cheese rhythmbox gnome-boxesd orca gnome-contacts samba-client gnome-getting-started-docs nautilus-sendto gnome-shell-extension-* libreoffice-* gnome-characters gnome-maps gnome-photos simple-scan virtualbox-guest-additions gedit gnome-software
```

Выключаем автообновление:

```sh
sudo systemctl stop packagekit.service
sudo systemctl disable packagekit.service
sudo systemctl mask packagekit.service
sudo systemctl stop packagekit-offline-update.service
sudo systemctl disable packagekit-offline-update.service
sudo systemctl mask packgekit-offline-update.service
```

Подключаем RPM Fusion:

```sh
sudo dnf install --nogpgcheck http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
```

Обновляем систему:

```sh
sudo dnf update --refresh
```


### Базовая настройка

Включаем HiDPI для TTY:

```sh
sudo dnf install terminus-fonts-console
```

И записываем в `/etc/vconsole.conf`:

```
KEYMAP="us"
FONT="ter-v32n"
```

```sh
sudo systemctl start systemd-vconsole-setup.service
```

Выключаем сканирование ФС:

```sh
dconf write /org/freedesktop/tracker/miner/files/crawling-interval -2
```

Выключаем засыпание компьютера при закрытии крышки:

1. `sudo vi /etc/systemd/logind.conf`
2. Ставим `HandleLidSwitch=lock`

Копируем шрифт:

```sh
sudo dnf install terminus-fonts-console terminus-fonts-grub2
sudo cp /usr/share/grub/ter-u32n.pf2 /boot/efi/EFI/fedora/fonts/
```

Добавляем в `/etc/default/grub`:

```
GRUB_FONT="/boot/efi/EFI/fedora/fonts/firamono.pf2"
GRUB_TERMINAL_OUTPUT="gfxterm"
```

Пересобираем GRUB:

```sh
sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
```

Перезагружаемся.


### Текстовые редакторы

Устанавливаем GNOME Builder и nano:

```sh
sudo dnf install nano gnome-builder wmctrl
su -c 'echo "export EDITOR=nano" >> /etc/profile'
```

Установить Атом:

```sh
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub io.atom.Atom
```

Устанавливаем темы и плагины из [`Atom.md`](./Atom.md).

Установить утилиту для diff:

```sh
sudo wget https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy -O /usr/local/bin/diff-so-fancy
sudo chmod a+x /usr/local/bin/diff-so-fancy
```


### Личные файлы

Скопировать конфиги:

```sh
~/Dev/environment/bin/copy-env system
```

Устанавливаем пакеты для расшифровки:

```sh
sudo dnf install fuse-encfs
```

Скопировать `.Private/`. Открыть его и скопировать папки `.ssh/`, `.gnupg/` и `.kube/`.

Ставим правильные права на ключи:

```sh
chmod 744 ~/.ssh
chmod 700 ~/.gnupg/
chmod 644 ~/.ssh/* ~/.gnupg/*
chmod 700 ~/.gnupg/private-keys-v1.d
chmod 600 ~/.ssh/id_ed25519 ~/.gnupg/secring.gpg ~/.gnupg/private-keys-v1.d/* ~/.gnupg/random_seed
```

Устанавливаем 2FA через ключ:

```sh
sudo dnf install yubioath-desktop
```


### Терминал

Устанавливаем zsh:

```sh
sudo dnf install zsh util-linux-user
chsh -s /bin/zsh
rm ~/.bash_history ~/.bash_logout
```

Устанавливаем Antigen:

```sh
curl -L git.io/antigen > ~/.antigen.zsh
source ~/.antigen.zsh
```

Создаём `/root/.zshrc`:

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

Перезагружаемся.


### Настройка GNOME

Ставим `seahorse` и выключаем пароль со связки ключей.

Открываем Настройки:

- **Поиск:** оставляем только «Калькулятор».
- **Фон:** ставим треугольники на экран блокировки.
- **Сетевые учётные записи:** подключить Google.
- **Энергопитание:** выключаем «Уменьшать яркость при простое»,
  ставим «Выключение экрана» в «Никогда».
- **Устройства → Дисплей:** включаем ночную подсветку с 23:00 до 06:00.
- **Устройства → Мышь и сенсорная панель:** скорость мыши на максимум,
  скорость панели поднимаем, включаем «Нажатие касанием».
- **Подробности → Пользователи:** ставим аватарку из этой папки
  и автоматический вход.

Выставляем настройки клавиатуры:

```sh
dconf write /org/gnome/desktop/input-sources/xkb-options "['grp_led:caps', 'lv3:ralt_switch', 'misc:typo', 'nbsp:level3', 'lv3:lsgt_switch', 'grp:shift_caps_switch']"
```

В Терминале:

- Параметры → Общие: выключить «Показывать панель меню …».
- Параметры профиля → Общие: выключить «Подавать гудок».

В Nautilus:

- Параметры → Вид: включить «Помещать папки перед файлами».
- Параметры → Поведение: включить «Открыть объекты одним щелчком».

Ставим расширения из [`GNOME.md`](./GNOME.md).

Добавляем Сан-Франциско, Москву, Пекин и Владивосток в Часы.

Установить шрифт Fira Mono и Fira Code:

```sh
sudo dnf install mozilla-fira-mono-fonts
mkdir -p ~/.local/share/fonts
for type in Bold Light Medium Regular Retina; do
  file_path="~/.local/share/fonts/FiraCode-${type}.ttf"
  file_url="https://github.com/tonsky/FiraCode/blob/master/distr/ttf/FiraCode-${type}.ttf?raw=true"
  wget -O "${file_path}" "${file_url}"
done
fc-cache -f
```

Установить GNOME Tweak Tool:

```sh
sudo dnf install gnome-tweak-tool
```

И выставить в нём настройки:

- **Основное:** включить «Сверхусиление».
- **Верхняя панель:** включить «заряд в процентах», «дату» и «секунды».
- **Внешний вид:** обои берём из этой папки.
- **Заголовки окон:** двойное нажатие — «toggle maximize vertical»,
  средней — «toggle maximize».
- **Клавиатура и мышь:** выключить «Вставка при нажатии средней кнопки мышки»
  и ставим «Adaptive» в профиле ускорения.
- **Окна:** выключаем «Активные края».
- **Расширения:**
  - **Emoji selector:** выключаем «Always show the icon».
  - **Gsconnect:** подключаем телефон.
  - **Icon Hider:** убираем `appMenu` и `keyboard`. Скрываю её иконку.
  - **Screenshot Tool:** убираем «Показывать иконку». Ставим «Автоматически
    сохранять скриншот» в «Загрузки» с именем `{Y}{m}{d}{H}{M}{S}`. Включаем
    Imgur с автоматическим открытием ссылки.
- **Шрифты:** моноширный в «Fira Code Retina».

Удаляем папки иконок:

```sh
gsettings set org.gnome.desktop.app-folders folder-children "['']"
```

Оставить в доке по-умолчанию только Фаерфокс, Наутилус и Терминал.


### Папки

Создаём шаблон пустого файла:

```sh
mkdir ~/.local/share/desktop
mkdir ~/.local/share/templates
touch ~/.local/share/templates/Пустой\ файл
```

Исправляем папки по-умолчанию `~/.config/user-dirs.dirs`:

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

Чистим закладки:

```sh
echo "" > ~/.config/gtk-3.0/bookmarks
```

Удаляем лишние папки:

```sh
rm -R ~/Documents ~/Pictures ~/Music ~/Public ~/Templates ~/Desktop
```


### Остальное ПО

Устанавливаем кодеки:

```sh
sudo dnf install amrnb amrwb faac faad2 flac gstreamer1-libav gstreamer1-plugins-bad-freeworld gstreamer-ffmpeg gstreamer-plugins-bad-nonfree gstreamer-plugins-espeak gstreamer-plugins-fc gstreamer-plugins-ugly lame libdca libmad libmatroska x264 x265 xvidcore gstreamer1-plugins-bad-free gstreamer1-plugins-base gstreamer1-plugins-good gstreamer-plugins-bad gstreamer-plugins-base gstreamer1-plugins-ugly-free
```

Устанавливаем программы:

```sh
sudo dnf install mpv unrar p7zip p7zip-plugins
```

Устанавливаем шрифты от Microsoft:

```sh
sudo dnf install https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm
```

Ставим Хром:

```sh
sudo dnf install fedora-workstation-repositories
sudo dnf config-manager --set-enabled google-chrome
sudo dnf install google-chrome-stable
```

Скачиваем [файл настроек VPN](https://www.expressvpn.com/ru/setup#manual) для Гонконга.


Устанавливаем GIMP, Telegram, Fragments, Transmission и Zoom:

```sh
flatpak install flathub com.transmissionbt.Transmission
flatpak install flathub de.haeckerfelix.Fragments
flatpak install flathub org.telegram.desktop
flatpak install flathub org.gimp.GIMP
flatpak install flathub us.zoom.Zoom
```


### Разработка

Устанавливаем пакеты:

```sh
sudo dnf install git tig ripgrep exa
```

Устанавливаем `node` и `yarn`:

```sh
sudo dnf install https://rpm.nodesource.com/pub_13.x/fc/30/x86_64/nodesource-release-fc30-1.noarch.rpm
sudo wget https://dl.yarnpkg.com/rpm/yarn.repo -O /etc/yum.repos.d/yarn.repo
sudo dnf install yarn nodejs
```

Устанавливаем Ruby:

```sh
sudo dnf install ruby gcc automake gdbm-devel libffi-devel libyaml-devel openssl-devel ncurses-devel readline-devel zlib-devel gcc-c++ libxml2 libxml2-devel libxslt libxslt-devel postgresql-devel sqlite-devel ruby-devel rpm-build
gem install bundler
```

Устанавливаем [Helm](https://github.com/helm/helm/releases).

Устанавливаем контейнеры:

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

Исправляем [баг](https://github.com/docker/for-linux/issues/665) Федоры:

```sh
sudo dnf install grubby
sudo grubby --update-kernel=ALL --args="systemd.unified_cgroup_hierarchy=0"
```

Устанавливаем Kubernetes:

```sh
sudo cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
sudo dnf install kubectl
```

Устанавливаем Keybase:

```sh
sudo dnf install https://prerelease.keybase.io/keybase_amd64.rpm
run_keybase
```

Удаляем Keybase из автозагрузки.

Устаналиваем [Projecteur](https://github.com/jahnf/Projecteur#download).
