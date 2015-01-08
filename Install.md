## Процесс разворачивания окружения

### 1. Скачать образ Федоры

Скачать образ:

```sh
wget http://download.fedoraproject.org/pub/fedora/linux/releases/21/Workstation/x86_64/iso/Fedora-Live-Workstation-x86_64-21-5.iso
```

Записать его на USB-флешку:

```sh
sudo yum remove liveusb-creator
sudo liveusb-creator
```

### 2. Установка

Открываем `/usr/lib64/python2.7/site-packages/pyanaconda` и исправляем методы
`is_valid_stage1_device` и `is_valid_stage2_device`, чтобы они всегда возвращали
`True`.

Запускаем установщик.

Английскую раскладку на первое место. Переключение клавиатура:
«Caps Lock (на первую раскладку), Shift+Caps Lock (на последнюю раскладку)».

Сеть и имя узла: «backfire».

Разбиение диска:

```
/boot/efi EFI  500 МиБ
/         ext4 LVM backfire-root
```

Пользовать:

- Полное имя: `Андрей Ситник`
- Имя пользователя: `ai`
- Сделать администратором

Перезагружаемся ещё раз в Live-USB. Подключаем диски установленной системы.

Создаём в `etc/kernel/postinst.d/99-update-efistub` скрипт обновления
EFI-файлов при обновлении ядра.

```sh
#!/bin/bash

rm -f /boot/efi/EFI/fedora/vmlinuz.efi
rm -f /boot/efi/EFI/fedora/initramfs.img
cp $(ls /boot/vmlinuz-* | sort -r | head -1) /boot/efi/EFI/fedora/vmlinuz.efi
cp $(ls /boot/initramfs-* | sort -r | head -1) /boot/efi/EFI/fedora/initramfs.img
```

Копируем файлы сами и делаем скрипт исполняемым:

```
chmod a+x etc/kernel/postinst.d/99-update-efistub
```

Установить ядро в качестве EFI-загрузчика:

```sh
UUID=$(cryptsetup luksUUID /dev/sda2)
efibootmgr -c -g -L "Fedora" -l '\EFI\fedora\vmlinuz.efi' -u "root=/dev/mapper/backfire-root rd.lvm.lv=backfire/root rd.luks.uuid=luks-$UUID ro rhgb quiet LANG=ru_RU.UTF-8 initrd=\EFI\fedora\initramfs.img"
```

### 3. Оптимизация для SSD

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

### 4. Обновление системы

Запускаем `seahorse` и убираем пароль со «Вход».

Удаляем GRUB:

```sh
sudo dnf remove shim grub2 grub2-tools grub2-efi
sudo rm -R /boot/grub2
```

Удаляем ненужные пакеты:

```sh
sudo dnf remove gedit seahorse cheese devassistant evolution evolution-ews evolution-help bijiben rhythmbox shotwell gnome-boxes gnome-documents gnome-weather empathy vinagre brasero-libs desktop-backgrounds-basic orca gnome-contacts gnome-getting-started-docs gnome-shell-extension-* libreoffice-* setroubleshoot*
```

Подключаем RPM Fusion:

```sh
su -c 'yum localinstall --nogpgcheck http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm'
```

Подключаем Russian Fedora:

```sh
su -c 'yum install --nogpgcheck http://mirror.yandex.ru/fedora/russianfedora/russianfedora/free/fedora/russianfedora-free-release-stable.noarch.rpm http://mirror.yandex.ru/fedora/russianfedora/russianfedora/nonfree/fedora/russianfedora-nonfree-release-stable.noarch.rpm http://mirror.yandex.ru/fedora/russianfedora/russianfedora/fixes/fedora/russianfedora-fixes-release-stable.noarch.rpm'
```

Обновляем систему:

```sh
sudo dnf update
```

Удаляем программы, которые появятся после обновления:

```sh
sudo dnf remove paprefs pavucontrol pavumeter paman
```

### 5. Настройка системы

Скопировать эту папку в `~/Dev/`.

Открываем Настройки:

- **Конфиденциальность:** включаем «Сервисы местоположения».
- **Поиск:** выключаем «Терминал» и «Центр приложений».
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
- Параметры → Поведение: включить «Открыть объекты одним щелчком»
  и «Включить команду удаления, не использующую корзину».

### 6. Оборудование

Чиним тачскрин после сна.
Создаём файл `/usr/lib/systemd/system-sleep/touchscreen`:

```sh
#!/bin/sh

case $1 in
post)
    rmmod hid_multitouch && modprobe hid_multitouch
    ;;
esac
```

И даём права на запуск:

```sh
sudo chmod a+x /usr/lib/systemd/system-sleep/touchscreen
```

Чиним WiFi:

```sh
dnf install kmod-wl
```

Перезагружаемся.

## 7. Браузеры

Включаем ретину в Фаерфоксе. Открываем `about:config`
и выставляем `layout.css.devPixelsPerPx` равным `2`.

Ставим для Фаерфокса расширения:

- [HTitle](https://addons.mozilla.org/RU/firefox/addon/htitle/)
- [GNOME 3](https://addons.mozilla.org/ru/firefox/addon/adwaita/)

Ставим Хром с `google.ru/chrome`.

Исправить масштаб страницы по умолчанию:
Настройки → Показать дополнительные настройки → Веб-контент
и выставить «Рабочий стол» в Скаченные файлы.

Включить плавную прокрутку в `chrome://flags`.

Посмотреть ID-тачскрина в `xinput list` и добавить `--touch-devices=x`
в опции ярлыка.

Авторизоваться в Хроме. Авторизоваться в Твиттере, ГитХабе, Гиттере, Слаках,
ВКонтакте, Фидли, Ютуб, Фейсбуке, Амплифере и Википедии.

Сделать аккаунты «Английский», «Автопрефиксер» и «PostCSS».

## 8. Настройки GNOME

Заходим на `extensions.gnome.org` и ставим расширения:

- [Always Zoom Workspaces](https://extensions.gnome.org/extension/503/always-zoom-workspaces/)
- [Autohide Battery](https://extensions.gnome.org/extension/595/autohide-battery/)
- [Icon Hider](https://extensions.gnome.org/extension/351/icon-hider/)
  и отключаем `a11y`, `keyboard` и индикатор расширения
- [Imgur Screenshot Uploader](https://extensions.gnome.org/extension/683/imgur-screenshot-uploader/)
  и отключаем индикатор расширения
- [Launch new instance](https://extensions.gnome.org/extension/600/launch-new-instance/)
- [Panel World Clock](https://extensions.gnome.org/extension/697/panel-world-clock/)
  и добавляем Калифорнию, Москву, Пекин и Владивосток
  и стави 0 в «Number of clocks»
- [Remove Dropdown Arrows](https://extensions.gnome.org/extension/800/remove-dropdown-arrows/)
- [Refresh Wifi Connections](https://extensions.gnome.org/extension/905/refresh-wifi-connections/)
- [User Themes](https://extensions.gnome.org/extension/19/user-themes/)

Установить шрифт Fira Mono:

```sh
sudo dnf install mozilla-fira-mono-fonts
```

Установить иконки и тему:

```sh
sudo curl -o /etc/yum.repos.d/moka-stable.repo http://mokaproject.com/packages/rpm/moka-stable.repo
sudo dnf install faba-icon-theme moka-icon-theme moka-gnome-shell-theme --nogpgcheck
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
  моноширный в «Fira Mono OT Regular», хиттинг в Slight

## 9. Основные программы

Устанавливаем кодеки:

```sh
sudo dnf install amrnb amrwb faac faad2 flac gstreamer1-libav gstreamer1-plugins-bad-freeworld gstreamer1-plugins-ugly gstreamer-ffmpeg gstreamer-plugins-bad-nonfree gstreamer-plugins-espeak gstreamer-plugins-fc gstreamer-plugins-ugly gstreamer-rtsp lame libdca libmad libmatroska x264 xvidcore gstreamer1-plugins-bad-free gstreamer1-plugins-base gstreamer1-plugins-good gstreamer-plugins-bad gstreamer-plugins-bad-free gstreamer-plugins-base gstreamer-plugins-good
```

Устанавливаем программы:

```sh
sudo dnf install man-pages-ru mpv gimp unrar nano p7zip p7zip-plugins inkscape
```

Устаналивливаем шрифты от Microsoft:

```sh
sudo dnf install https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm
```

## 10. Личные файлы

Скопировать папку `bin/` как `~/.bin/`.

Устанавливаем пакеты для расшировки:

```sh
sudo dnf install fuse-encfs
```

Скопировать `.Личное/`. Открыть его и скопировать папки `.ssh/` и `.gnupg/`.

## 11. Папки

Создаём шаблон пустого файла:

```sh
touch ~/Шаблоны/Пустой\ файл
```

Исправляем папки по-умолчанию. Записываем в `~/.config/user-dirs.dirs`:

```
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

Удаляем `Видео/`, `Документы/`, `Изображения/`, `Музыка/` и `Общедоступные/`.

Выставляем иконки `/usr/share/icons/Faba/48x48/places/folder-documents.svg`
для папки `Dev/`.

## 12. Разработка

Установить пакеты:

```sh
sudo dnf install gitg ack npm nodejs ack redis gcc automake gdbm-devel libffi-devel libyaml-devel openssl-devel ncurses-devel readline-devel zlib-devel rpm-build postgresql postgresql-server
```

Запускаем PostgreSQL:

```sh
sudo postgresql-setup initdb
sudo systemctl enable redis
sudo systemctl enable postgresql
```

Скопировать настройки из папки `config/`.

Устаналиваем `chruby`:

```sh
sudo dnf install ftp://fr2.rpmfind.net/linux/opensuse/distribution/11.4/repo/oss/suse/x86_64/checkinstall-1.6.2-8.1.x86_64.rpm
wget -O chruby.tar.gz https://github.com/postmodern/chruby/archive/v0.3.9.tar.gz
tar -xzvf chruby.tar.gz
cd chruby-0.3.9/
mkdir /usr/local/share/doc
LANG=en checkinstall
sudo dnf install /home/ai/rpmbuild/RPMS/x86_64/*.rpm
cd ..
rm -Rf chruby-0.3.9/
rm chruby.tar.gz
rm -R rpmbuild/
sudo dnf remove checkinstall
```

Собираем последний Ruby:

```sh
~/.bin/build-ruby 2.2.0
source /usr/local/share/chruby/chruby.sh
chruby 2.2
gem install bundler
```

Устанавливаем Trimage:

```sh
sudo dnf install ftp://ftp.pbone.net/vol2/www.pclinuxos.com/pclinuxos/apt/pclinuxos/2011/RPMS.x86_64/trimage-1.0.5-3pclos2013.noarch.rpm
```

Ставим `nano` консольным редактором по умолчанию:

```sh
su -c 'echo "export EDITOR=nano" >> /etc/profile'
```

## 13. Atom

Установить Атом из `atom.io`.

Включить HiDPI а Атоме:

```sh
gsettings set org.gnome.desktop.interface scaling-factor 2
```

Устанавливаем шрифт Fira Code:

```sh
mkdir .fonts/
wget https://github.com/tonsky/FiraCode/raw/master/FiraCode-Regular.otf -O .fonts/FiraCode-Regular.otf
fc-cache -v
```

## 14. Ярлыки

Оставить в доке по-умолчанию только Хром, Наутилус и Терминал.
