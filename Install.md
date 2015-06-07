## Как я ставлю свою систему

### Образ Федоры

Скачиваем образ:

```sh
wget http://download.fedoraproject.org/pub/fedora/linux/releases/22/Workstation/x86_64/iso/Fedora-Live-Workstation-x86_64-22-3.iso
```

Записываем его на USB-флешку:

```sh
sudo dnf install liveusb-creator
sudo liveusb-creator
```

### Установка

Открываем `/usr/lib64/python2.7/site-packages/pyanaconda/bootloader.py`
и исправляем методы `is_valid_stage1_device` и `is_valid_stage2_device`,
чтобы они всегда возвращали `True`.

Запускаем установщик.

1. Английскую раскладку на первое место. Переключение раскладок:
   «Caps Lock (на первую раскладку), Shift+Caps Lock (на последнюю раскладку)».
2. Сеть и имя узла: «backfire».
3. Разбиение диска:

    ```
   /boot/efi EFI  500 МиБ
   /         ext4 LVM backfire-root
    ```
4. Пользовать:
   - Полное имя: `Андрей Ситник`
   - Имя пользователя: `ai`
   - Сделать администратором

Перезагружаемся ещё раз в Live-USB. Подключаем диски установленной системы.

Создаём в скрипт обновления EFI-файлов при обновлении ядра
в `etc/kernel/postinst.d/99-update-efistub`:

```sh
#!/bin/bash

rm -f /boot/efi/EFI/fedora/vmlinuz.efi
rm -f /boot/efi/EFI/fedora/initramfs.img
cp $(ls /boot/vmlinuz-* | sort -r | head -1) /boot/efi/EFI/fedora/vmlinuz.efi
cp $(ls /boot/initramfs-* | sort -r | head -1) /boot/efi/EFI/fedora/initramfs.img
```

```sh
sudo chmod a+x etc/kernel/postinst.d/99-update-efistub
```

Устанавливаем ядро в качестве EFI-загрузчика:

```sh
sudo bash
UUID=$(cryptsetup luksUUID /dev/sda2)
efibootmgr -c -g -L "Fedora" -l '\EFI\fedora\vmlinuz.efi' -u "root=/dev/mapper/backfire-root rd.lvm.lv=backfire/root rd.luks.uuid=luks-$UUID ro rhgb quiet LANG=ru_RU.UTF-8 initrd=\EFI\fedora\initramfs.img"
```

Копируем первое ядро руками.

### Оптимизация для SSD

Открываем `etc/fstab`.

Добавляем опцию `noatime` для корневой системы.

Переносим `/tmp` и `/var/log` в оперативную память:

```
none /var/tmp  tmpfs noatime 0 0
none /tmp/     tmpfs noatime 0 0
```

Чистим каталоги `tmp` и `var/tmp`.

Перезагружаемся в систему и включаем TRIM:

```sh
sudo systemctl enable fstrim.timer
```

### Обновление системы

Запускаем `seahorse` и убираем пароль со «Вход».

Удаляем GRUB:

```sh
sudo dnf remove shim grub2 grub2-tools grub2-efi
sudo rm -R /boot/grub2
sudo rm /boot/efi/EFI/fedora/grub*
```

Удаляем ненужные пакеты:

```sh
sudo dnf remove gedit cheese devassistant evolution evolution-ews evolution-help bijiben rhythmbox shotwell gnome-boxes gnome-documents gnome-weather empathy vinagre brasero-libs desktop-backgrounds-basic orca gnome-contacts gnome-maps yelp samba-client gnome-getting-started-docs nautilus-sendto seahorse gnome-font-viewer gucharmap gnome-shell-extension-* libreoffice-* setroubleshoot* devassistant*
```

Подключаем RPM Fusion:

```sh
su -c 'yum install --nogpgcheck http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm'
```

Подключаем Russian Fedora:

```sh
su -c 'yum install --nogpgcheck http://mirror.yandex.ru/fedora/russianfedora/russianfedora/free/fedora/russianfedora-free-release-stable.noarch.rpm http://mirror.yandex.ru/fedora/russianfedora/russianfedora/nonfree/fedora/russianfedora-nonfree-release-stable.noarch.rpm'
```

Обновляем систему:

```sh
sudo dnf update --refresh
```

### Настройка GNOME

Открываем Настройки:

- **Поиск:** выключаем «Nautilus», «Пароли и ключи», «Терминал»
  и «Центр приложений».
- **Фон:** ставим обои из этой папки.
- **Мышь и сенсорная панель:** включаем «Естественная прокрутка».
- **Энегропитание:** выключаем «Уменьшать яркость при простое»,
  ставим «Выключение экрана» в «Никогда».
- **Пользователи:** ставим аватарку из этой папки и «Автоматический вход».

Выставляем настройки клавиатуры:

```sh
dconf write /org/gnome/desktop/input-sources/xkb-options "['grp:shift_caps_switch', 'grp_led:caps', 'lv3:ralt_switch', 'misc:typo', 'nbsp:level3']"
```

В Терминале:

- Параметры → Общие: выключить «Показывать панель меню …».
- Параметры профиля → Общие: выключить «Продавать гудок».

В Nautilus:

- Параметры → Вид: включить «Помещать папки перед файлами».
- Параметры → Поведение: включить «Открыть объекты одним щелчком».

Выключаем сканирование ФС:

```sh
dconf write /org/freedesktop/tracker/miner/files/crawling-interval -2
```

### Оборудование

Чиним WiFi:

```sh
sudo dnf install kmod-wl
```

Перезагружаемся.

### VPN

Скачиваем сертификаты:

```sh
wget https://www.privateinternetaccess.com/openvpn/openvpn.zip
mkdir ~/.cert
unzip openvpn.zip -d ~/.cert/private-internet-access/
rm openvpn.zip
```

Создаём VPN-соединие:

1. Настройки → Сеть → + → VPN → OpenVPN.
2. Название: «Private Internet Access».
3. Шлюз: «germany.privateinternetaccess.com».
4. Тип: «Пароль».
5. Указываем Сертификат ЦС `ca.crt` из скаченной папки.
6. Дополнительно → Общие: оставляем только
   «Использовать для сжатия данных LZO».
7. Вводим логин и пароль.

### Браузеры

Ставим для Фаерфокса расширения:

- [HTitle](https://addons.mozilla.org/RU/firefox/addon/htitle/)
- [GNOME 3](https://addons.mozilla.org/ru/firefox/addon/adwaita/)

Ставим Хром:

```sh
sudo dnf install https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
```

Настройки → Показать дополнительные настройки:
выставить «Рабочий стол» в Скаченные файлы.

Включить «Плавная прокрутка» и «Переопределение списка программного рендеринга»
в `chrome://flags`.

Посмотреть ID-тачскрина в `xinput list` и добавить `--touch-devices=x`
в опции ярлыка.

Авторизоваться в Хроме. Авторизоваться в Твиттере, ГитХабе, Гиттере, Слаках,
ВКонтакте, Фидли, Ютуб, Фейсбуке, Амплифере и Википедии.

Сделать аккаунты «Английский», «Автопрефиксер» и «PostCSS».

Добавляем расширения «Evil Chrome» и «SaveFrom.net помощник».

### Внешний вид

Ставим расширения из `GNOME.md`. Добавляем Сан-Франциско, Москву, Пекин
и Владивосток в Часы.

Установить шрифт Fira Mono:

```sh
sudo dnf install mozilla-fira-mono-fonts
```

Установить иконки и тему:

```sh
sudo wget http://download.opensuse.org/repositories/home:snwh:moka-project/Fedora_21/home:snwh:moka-project.repo -O /etc/yum.repos.d/moka-project.repo
sudo dnf install faba-icon-theme moka-icon-theme moka-gnome-shell-theme
```

Улучшаем рендер шрифтов:

```sh
sudo dnf install freetype-freeworld
```

Установить GNOME Tweek Tool:

```sh
sudo dnf install gnome-tweek-tool
```

И выставить в нём настроки:

- **Верхняя панель:** включить «Показывать дату» и «Показывать секунды».
- **Внешний вид:** тему и иконки выставить в «Moka»
- **Рабочий стол:** включить «Показывать значки на рабочем столе» и выключить
  все стандартные иконки.
- **Шрифты:** заголовок окон в «PT Sans Bold», интерфейс в «PT Sans Regular»,
  моноширный в «Fira Mono Regular», хиттинг в Slight
- **Электропитание:** выставить «При нажатии кнопки выключения» в «Blank».

### Кодеки и шрифты

Устанавливаем кодеки:

```sh
sudo dnf install amrnb amrwb faac faad2 flac gstreamer1-libav gstreamer1-plugins-bad-freeworld gstreamer1-plugins-ugly gstreamer-ffmpeg gstreamer-plugins-bad-nonfree gstreamer-plugins-espeak gstreamer-plugins-fc gstreamer-plugins-ugly gstreamer-rtsp lame libdca libmad libmatroska x264 xvidcore gstreamer1-plugins-bad-free gstreamer1-plugins-base gstreamer1-plugins-good gstreamer-plugins-bad gstreamer-plugins-bad-free gstreamer-plugins-base gstreamer-plugins-good
```

Устанавливаем программы:

```sh
sudo dnf install man-pages-ru mpv gimp unrar p7zip p7zip-plugins inkscape
```

Устаналивливаем шрифты от Microsoft:

```sh
sudo dnf install https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm
```

### Личные файлы

Устанавливаем пакеты для расшировки:

```sh
sudo dnf install fuse-encfs
```

Скопировать `.Личное/`. Открыть его и скопировать папки `.ssh/` и `.gnupg/`.

### Папки

Создаём шаблон пустого файла:

```sh
touch ~/Шаблоны/Пустой\ файл
```

Исправляем папки по-умолчанию `~/.config/user-dirs.dirs`:

```sh
XDG_DESKTOP_DIR="$HOME/Рабочий стол"
XDG_DOWNLOAD_DIR="$HOME/Загрузки"
XDG_TEMPLATES_DIR="$HOME/Шаблоны"
XDG_PUBLICSHARE_DIR="$HOME/"
XDG_DOCUMENTS_DIR="$HOME/"
XDG_MUSIC_DIR="$HOME/"
XDG_PICTURES_DIR="$HOME/"
XDG_VIDEOS_DIR="$HOME/"
```

Чистим закладки:

```sh
echo "" > ~/.config/gtk-3.0/bookmarks
```

Удаляем лишние папки:

```sh
rm -R Видео Документы Изображения Музыка Общедоступные
```

Выставляем иконку `/usr/share/icons/Faba/48x48/places/folder-documents.svg`
для папки `Dev/`.

### Разработка

Копируем файлы настройки:

```sh
~/Dev/environment/bin/copy-env system
```

Устанавливаем пакеты:

```sh
sudo dnf install gitg ack redis postgresql postgresql-server postgresql-contrib
```

Запускаем PostgreSQL:

```sh
sudo postgresql-setup initdb
sudo systemctl enable redis
sudo systemctl enable postgresql
sudo systemctl start postgresql
sudo su postgres -c 'createuser -s ai'
```

Устаналиваем `chruby`:

```sh
sudo dnf install rpm-build
sudo dnf install ftp://fr2.rpmfind.net/linux/opensuse/distribution/11.4/repo/oss/suse/x86_64/checkinstall-1.6.2-8.1.x86_64.rpm
wget -O chruby.tar.gz https://github.com/postmodern/chruby/archive/v0.3.9.tar.gz
tar -xzvf chruby.tar.gz
cd chruby-0.3.9/
sudo mkdir /usr/local/share/doc
LANG=en checkinstall
sudo dnf install /home/ai/rpmbuild/RPMS/x86_64/*.rpm
cd ..
rm -Rf chruby-0.3.9/
rm chruby.tar.gz
rm -R rpmbuild/
sudo dnf remove checkinstall rpm-build
```

Собираем последний Ruby:

```sh
sudo dnf install gcc automake gdbm-devel libffi-devel libyaml-devel openssl-devel ncurses-devel readline-devel zlib-devel gcc-c++ libxml2 libxml2-devel libxslt libxslt-devel postgresql-devel
~/Dev/environment/bin/build-ruby 2.2.2
source /usr/local/share/chruby/chruby.sh
chruby 2.2
gem install bundler
```

Устаналиваем `node` и `npm`:

```sh
mkdir -p ~/.node/iojs/
wget https://iojs.org/dist/v2.2.1/iojs-v2.2.1-linux-x64.tar.xz
tar -xf iojs-* -C ~/.node/iojs --strip-components=1
rm iojs-*.xz
cd ~/.node/
./iojs/bin/npm install node-gyp
```

Устанавливаем Trimage:

```sh
sudo dnf install ftp://ftp.pbone.net/vol2/www.pclinuxos.com/pclinuxos/apt/pclinuxos/2011/RPMS.x86_64/trimage-1.0.5-3pclos2013.noarch.rpm
```

### Текстовые редакторы

Устанавливаем nano:

```sh
sudo dnf install nano
su -c 'echo "export EDITOR=nano" >> /etc/profile'
su -c "echo '
set autoindent
include \"/usr/share/nano/*.nanorc\"' >> /etc/nanorc"
```

Установить Атом:

```sh
wget https://atom.io/download/rpm -O atom.rpm
sudo dnf install atom.rpm
rm atom.rpm
```

Включить HiDPI в Атоме:

```sh
gsettings set org.gnome.desktop.interface scaling-factor 2
```

Устанавливаем темы и плагины из `Atom.md`.

Устанавливаем ngrok. Скачиваем [архив](https://ngrok.com/download).

```
unzip ngrok.zip
sudo cp ./ngrok /usr/local/bin/
```

### zsh

Устанавливаем zsh:

```sh
sudo dnf install zsh
chsh -s /usr/bin/zsh
rm ~/.bash_history ~/.bash_logout
```

Устанавливаем Antigen:

```sh
curl -L https://raw.githubusercontent.com/zsh-users/antigen/master/antigen.zsh > .antigen.zsh
source .antigen.zsh
```

### Ярлыки

Удаляем папки иконок:

```sh
mkdir -p ~/.config/autostart/
echo '#!/bin/sh
sleep 1
gsettings set org.gnome.desktop.app-folders folder-children "[]"' > ~/.config/autostart/clean-folder.sh
chmod a+x ~/.config/autostart/clean-folder.sh
echo "[Desktop Entry]
Type=Application
Name=Приложения без папок
Icon=accessories-system-cleaner
Exec=/home/ai/.config/autostart/clean-folder.sh
X-GNOME-Autostart-enabled=true" > ~/.config/autostart/clean-folder.desktop
```

Оставить в доке по-умолчанию только Хром, Наутилус и Терминал.
