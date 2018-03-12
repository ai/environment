## Как я ставлю свою систему

### Образ Федоры

Скачиваем образ. Записываем его на USB-флешку:

```sh
sudo dnf install mediawriter
mediawriter
```

### Установка

Открываем `/usr/lib64/python3.6/site-packages/pyanaconda/bootloader.py`
и исправляем методы `is_valid_stage1_device` и `is_valid_stage2_device`,
чтобы они всегда возвращали `True`.

Запускаем установщик.

1. Английскую раскладку на первое место. Переключение раскладок:
   «CapsLock (на первую раскладку), Shift+CapsLock (на последнюю раскладку)».
2. Разбиение диска:

    ```
   /boot/efi EFI  500 МиБ
   /         ext4 LVM Группа томов: blackjack
    ```

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

Копируем первое ядро руками.

Копируем EFI-загрузчик:

```sh
sudo cp usr/lib/systemd/boot/efi/systemd-bootx64.efi ../BOOT/EFI/fedora/
sudo mkdir -p ../BOOT/loader/entries
```

Создаём для него настройки. `../BOOT/loader/loader.conf`:

```
default fedora
```

Узнаём UUID диска:

```sh
sudo cryptsetup luksUUID /dev/mapper/blackjack-root
```

Создаём `boot/efi/loader/entries/fedora.conf` и заменяем 2 `UUID`:

```
title   Fedora
linux   /EFI/fedora/vmlinuz.efi
initrd  /EFI/fedora/initramfs.img
options root=/dev/mapper/luks-UUID rd.lvm.lv=blackjack/root rd.luks.uuid=luks-UUID ro rhgb quiet LANG=ru_RU.UTF-8
```

Открываем `etc/fstab`.

Добавляем опцию `noatime` для корневой системы.

Переносим `/tmp` и `/var/tmp` в оперативную память:

```
none /var/tmp  tmpfs noatime  0 0
none /tmp/     tmpfs noatime  0 0
/swapfile none swap  defaults 0 0
```

Чистим каталоги `tmp` и `var/tmp`.

Создаём swap-файл:

```sh
sudo fallocate -l 8G ./swapfile
sudo chmod 600 ./swapfile
sudo mkswap ./swapfile
```

Редактируем EFI:

```sh
sudo efibootmgr -b 0001 -B
sudo efibootmgr --create --disk /dev/nvme0n1 --label Fedora --loader "EFI/fedora/systemd-bootx64.efi"
```

Перезагружаемся в систему. Указываем имя по английски и логин `ai`.
Заходим в систему. Меняем имя на русское. И включаем автоматический вход.

Указываем имя ноутбуку:

```sh
hostnamectl set-hostname blackjack
```

Включаем TRIM:

```sh
sudo systemctl enable fstrim.timer
```

### Обновление системы

Удаляем GRUB:

```sh
sudo dnf remove grub2 grub2-tools grub2-efi
sudo rm -R /boot/grub2
sudo rm /boot/efi/EFI/fedora/grub*
```

Удаляем ненужные пакеты:

```sh
sudo dnf remove gedit cheese evolution rhythmbox gnome-boxes gnome-documents orca gnome-contacts samba-client gnome-getting-started-docs nautilus-sendto gnome-shell-extension-* libreoffice-* setroubleshoot* gnome-characters gnome-maps gnome-calendar
```

Подключаем RPM Fusion:

```sh
sudo dnf install --nogpgcheck http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
```

Подключаем Russian Fedora:

```sh
sudo dnf install --nogpgcheck http://mirror.yandex.ru/fedora/russianfedora/russianfedora/free/fedora/russianfedora-free-release-stable.noarch.rpm http://mirror.yandex.ru/fedora/russianfedora/russianfedora/nonfree/fedora/russianfedora-nonfree-release-stable.noarch.rpm http://mirror.yandex.ru/fedora/russianfedora/russianfedora/fixes/fedora/russianfedora-fixes-release-stable.noarch.rpm
```

Обновляем систему:

```sh
sudo dnf update --refresh
```

Включаем HiDPI для TTY:

```sh
sudo dnf install terminus-fonts-console
```

И записаем в `/etc/vconsole.conf`:

```
KEYMAP="us"
FONT="ter-v32n"
```

Перезагружаемся.

### Настройка GNOME

Открываем Настройки:

- **Поиск:** выключаем «Терминал» и «Центр приложений».
- **Фон:** ставим обои из этой папки и стандартный фон на экран блокировки.
- **Мышь и сенсорная панель:** чувствительность на максимум,
  включаем «Нажатие касанием».
- **Энегропитание:** выключаем «Уменьшать яркость при простое»,
  ставим «Выключение экрана» в «Никогда».
- **Пользователи:** ставим аватарку из этой папки и «Автоматический вход».
- **Клавиатура:** заходим в «Комбинации клавиш» и очищаем «Сохранять снимок …».

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

Выключаем сканирование ФС:

```sh
dconf write /org/freedesktop/tracker/miner/files/crawling-interval -2
```

### Браузеры

Ставим Хром:

```sh
wget https://dl.google.com/linux/linux_signing_key.pub
sudo rpm --import linux_signing_key.pub
rm linux_signing_key.pub
sudo dnf install https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
```

Настройки: «Раннее открытые вкладки».
Показать дополнительные настройки: выставить «Рабочий стол» в Скаченные файлы.

Авторизоваться в Хроме. Авторизоваться в Твиттере, ГитХабе, Гиттере, Слаках,
ВКонтакте, Фидли, Фейсбуке, Амплифере и Википедии, Телеграме.

Добавляем расширения «[Evil Chrome]».

[Evil Chrome]:           https://evilmartians.slack.com/files/yaroslav/F0XAA0LF4/evil-chrome__1_.crx

### VPN

Скачиваем файлы настроек для Германии и Гонконга с
[ExpressVPN](https://www.expressvpn.com/ru/setup#manual).

Создаём VPN-соединения:

1. Настройки → Сеть → + → VPN → Импортировать из файла.
2. Название: «ExpressVPN страна».
3. Копируем имя пользователя и пароль.

### Внешний вид

Ставим расширения из [`GNOME.md`](./GNOME.md).

Добавляем Сан-Франциско, Москву, Пекин и Владивосток в Часы.

Установить шрифт Fira Mono и Fire Code:

```sh
sudo dnf install mozilla-fira-mono-fonts
```

Скачиваем файлы FiraCode с [репозитория](https://github.com/tonsky/FiraCode).

Установить иконки и тему:

```sh
sudo dnf config-manager --add-repo http://download.opensuse.org/repositories/home:snwh:moka/Fedora_25/home:snwh:moka.repo
sudo dnf install faba-icon-theme moka-icon-theme
```

Улучшаем рендер шрифтов:

```sh
sudo dnf install freetype-freeworld
```

Установить GNOME Tweek Tool:

```sh
sudo dnf install gnome-tweak-tool
```

И выставить в нём настроки:

- **Верхняя панель:** включить «Показывать дату» и «Показывать секунды».
- **Внешний вид:** иконки выставить в «Moka».
- **Звук:** включить «Сверхусиление».
- **Клавиатура и мышь:** выключить «Вставка при нажатии средней кнопки мышки».
- **Шрифты:** заголовок окон в «PT Sans Bold», интерфейс в «PT Sans Regular»,
  моноширный в «Fira Code Retina».

### Кодеки и шрифты

Устанавливаем кодеки:

```sh
sudo dnf install amrnb amrwb faac faad2 flac gstreamer1-libav gstreamer1-plugins-bad-freeworld gstreamer1-plugins-ugly gstreamer-ffmpeg gstreamer-plugins-bad-nonfree gstreamer-plugins-espeak gstreamer-plugins-fc gstreamer-plugins-ugly gstreamer-rtsp lame libdca libmad libmatroska x264 xvidcore gstreamer1-plugins-bad-free gstreamer1-plugins-base gstreamer1-plugins-good gstreamer-plugins-bad gstreamer-plugins-bad-free gstreamer-plugins-base gstreamer-plugins-good
```

Устанавливаем программы:

```sh
sudo dnf install man-pages-ru mpv gimp unrar p7zip p7zip-plugins inkscape transmission-gtk
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

Скопировать `.Личное/`. Открыть его и скопировать папки `.ssh/`, `.gnupg/` и `.kube/`.

### Папки

Создаём шаблон пустого файла:

```sh
touch ~/.templates/Пустой\ файл
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
XDG_VIDEOS_DIR="$HOME/Видео"
```

Чистим закладки:

```sh
echo "" > ~/.config/gtk-3.0/bookmarks
```

Удаляем лишние папки:

```sh
rm -R ~/Документы ~/Изображения ~/Музыка ~/Общедоступные
```

### Разработка

Копируем файлы настройки:

```sh
~/Dev/environment/bin/copy-env system
```

Устанавливаем пакеты:

```sh
sudo dnf install git tig ack redis postgresql postgresql-server postgresql-contrib
```

Устанавливаем Java:

```sh
sudo dnf install java-1.8.0-openjdk-…
```

Запускаем PostgreSQL:

```sh
sudo postgresql-setup initdb
sudo systemctl enable redis
sudo systemctl enable postgresql
sudo systemctl start postgresql
sudo su postgres -c 'createuser -s ai'
```

В `/var/lib/pgsql/data/pg_hba.conf` меняем строчку на:

```
host    all             all             127.0.0.1/32            trust
```

Устаналиваем `chruby`:

```sh
dnf copr enable nwallace/ruby-tools
sudo dnf install chruby
```

Собираем Ruby:

```sh
sudo dnf install gcc automake gdbm-devel libffi-devel libyaml-devel openssl-devel ncurses-devel readline-devel zlib-devel gcc-c++ libxml2 libxml2-devel libxslt libxslt-devel postgresql-devel sqlite-devel
~/Dev/environment/bin/build-ruby 2.3.5
source /usr/local/share/chruby/chruby.sh
chruby 2.3
gem install bundler
```

Устаналиваем `node` и `yarn`:

```sh
sudo bash
curl --silent --location https://rpm.nodesource.com/setup_9.x | bash -
dnf install -y nodejs
wget https://dl.yarnpkg.com/rpm/yarn.repo -O /etc/yum.repos.d/yarn.repo
dnf install yarn
```

Устанавливаем Trimage:

```sh
sudo dnf config-manager --add-repo http://download.opensuse.org/repositories/home:zhonghuaren/Fedora_25/home:zhonghuaren.repo
sudo dnf install trimage
```

Устанавливаем Deis:

```
curl -sSL http://deis.io/deis-cli/install-v2.sh | bash
sudo mv $PWD/deis /usr/local/bin/deis
rm $PWD/deis
deis login https://deis.amplifr.com
```

### Текстовые редакторы

Устанавливаем nano:

```sh
sudo dnf install nano
su -c 'echo "export EDITOR=nano" >> /etc/profile'
```

Установить Атом:

```sh
wget https://atom.io/download/rpm -O atom.rpm
sudo dnf install atom.rpm
rm atom.rpm
```

Устанавливаем темы и плагины из [`Atom.md`](./Atom.md).

### zsh

Устанавливаем zsh:

```sh
sudo dnf install zsh
chsh -s /usr/bin/zsh
rm ~/.bash_history ~/.bash_logout
```

Устанавливаем Antigen:

```sh
curl https://cdn.rawgit.com/zsh-users/antigen/v1.3.2/bin/antigen.zsh > ~/.antigen.zsh
source ~/.antigen.zsh
```

Создаём `/root/.zshrc`:

```
source /home/ai/.prompt/async.zsh
source /home/ai/.prompt/main.zsh
```

Подключаем телефон. Устанавливаем инструменты отладки.

```sh
sudo dnf install adb
sudo systemctl start adb
```

Разрешаем отладку с этого устройства на телефоне.

### Ярлыки

Удаляем папки иконок:

```sh
gsettings set org.gnome.desktop.app-folders folder-children "['']"
```

Оставить в доке по-умолчанию только Хром, Наутилус и Терминал.

### Чаты

Устанавливаем Keybase:

```sh
sudo dnf install https://prerelease.keybase.io/keybase_amd64.rpm
run_keybase
```

Удаляем Keybase из автозагрузки.

Устанавливаем Zoom:
[zoom.us/download?os=linux](https://zoom.us/download?os=linux)

Устанавливаем ripgrep:

```sh
sudo dnf copr enable carlwgeorge/ripgrep
sudo dnf install ripgrep
```
