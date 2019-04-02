## Как я ставлю свою систему

### Подготовка

Скачиваем образ [Fedora](https://getfedora.org/ru/workstation/).
Записываем его на USB-флешку:

```sh
sudo dnf install mediawriter
```

Написываем на внешний диск:

1. `.Личное/`
2. `Видео/`
3. `Dev/`
4. `.mozilla`

### Установка

Запускаем установщик.

1. Английскую раскладку на первое место. Переключение раскладок:
   «CapsLock (на первую раскладку), Shift+CapsLock (на последнюю раскладку)».
2. В ручном разбиение диска выбираем автоматически создать разделы.
3. Переименовыем том в `blackjack`.
4. Удаляем `root` и `home`.
5. Создаём `root` снова на весь размер.

Перезагружаемся ещё раз в Live-USB. Подключаем диски установленной системы.

Открываем `etc/fstab`.

Добавляем опцию `noatime` для корневой системы.

Переносим `/tmp` и `/var/tmp` в оперативную память:

```
none /var/tmp  tmpfs noatime  0 0
none /tmp/     tmpfs noatime  0 0
```

Чистим каталоги `tmp` и `var/tmp`.

В BIOS меняем порядок загрузки.

Перезагружаемся в систему. Указываем имя по английски и логин `ai`.
Заходим в систему. Меняем имя на русское. И включаем автоматический вход.

Указываем имя ноутбуку:

```sh
sudo hostnamectl set-hostname blackjack
```

Включаем TRIM:

```sh
sudo systemctl enable fstrim.timer
```

### Обновление системы

Удаляем ненужные пакеты:

```sh
sudo dnf remove cheese evolution rhythmbox gnome-boxes gnome-documents orca gnome-contacts samba-client gnome-getting-started-docs nautilus-sendto gnome-shell-extension-* libreoffice-* gnome-characters gnome-maps gnome-photos simple-scan virtualbox-guest-additions
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

```sh
systemctl start systemd-vconsole-setup.service
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
- **Сетевые учётные записи:** подключить Google.

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

Ставим `seahorse` и выключаем пароль со связик ключей.

Ставим Хром:

```sh
wget https://dl.google.com/linux/linux_signing_key.pub
sudo rpm --import linux_signing_key.pub
rm linux_signing_key.pub
sudo dnf install https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
```

Настройки: «Раннее открытые вкладки».

Авторизоваться в Хроме. Авторизоваться в Твиттере, ГитХабе, Гиттере, Слаках,
ВКонтакте, Фидли, Фейсбуке, Амплифере и Википедии, Телеграме.

Добавляем расширения «[Evil Chrome]».

[Evil Chrome]: https://evilmartians.slack.com/files/yaroslav/F0XAA0LF4/evil-chrome__1_.crx

### VPN

Скачиваем файлы настроек для Германии и Гонконга с
[ExpressVPN](https://www.expressvpn.com/ru/setup#manual).

Создаём VPN-соединения:

1. Настройки → Сеть → + → VPN → Импортировать из файла.
2. Название: «ExpressVPN Германия» и «ExpressVPN Гонконг».
3. Копируем имя пользователя и пароль.

### Внешний вид

Ставим расширения из [`GNOME.md`](./GNOME.md).

Добавляем Сан-Франциско, Москву, Пекин и Владивосток в Часы.

Установить шрифт Fira Mono и Fire Code:

```sh
sudo dnf install mozilla-fira-mono-fonts
```

Скачиваем файлы [FiraCode](https://github.com/tonsky/FiraCode).

Установить иконки и тему:

```sh
sudo dnf install numix-icon-theme-circle
```

Установить GNOME Tweek Tool:

```sh
sudo dnf install gnome-tweak-tool
```

И выставить в нём настроки:

- **Основное:** включить «Сверхусиление».
- **Верхняя панель:** включить «Показывать дату» и «Показывать секунды».
- **Внешний вид:** иконки выставить в «Numix-Circle».
- **Клавиатура и мышь:** выключить «Вставка при нажатии средней кнопки мышки»
  и ставим «Adaptive» в профиле ускорения.
- **Окна:** выключаем «Активные края».
- **Шрифты:** заголовок окон в «PT Sans Bold», интерфейс в «PT Sans Regular»,
  моноширный в «Fira Code Retina».

### Кодеки и шрифты

Устанавливаем кодеки:

```sh
sudo dnf install amrnb amrwb faac faad2 flac gstreamer1-libav gstreamer1-plugins-bad-freeworld gstreamer-ffmpeg gstreamer-plugins-bad-nonfree gstreamer-plugins-espeak gstreamer-plugins-fc gstreamer-plugins-ugly gstreamer-rtsp lame libdca libmad libmatroska x264 x265 xvidcore gstreamer1-plugins-bad-free gstreamer1-plugins-base gstreamer1-plugins-good gstreamer-plugins-bad gstreamer-plugins-bad-free gstreamer-plugins-base gstreamer-plugins-good
```

Устанавливаем программы:

```sh
sudo dnf install man-pages-ru gnome-mpv unrar p7zip p7zip-plugins inkscape transmission-gtk gimp
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

Ставим правильные права на ключи:

```sh
chmod 744 ~/.ssh ~/.gnupg/
chmod 644 ~/.ssh/* ~/.gnupg/*
chmod 700 ~/.gnupg/private-keys-v1.d
chmod 600 ~/.ssh/id_rsa ~/.ssh/id_ed25519 ~/.gnupg/secring.gpg ~/.gnupg/private-keys-v1.d/* ~/.gnupg/random_seed
```

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
XDG_DOWNLOAD_DIR="$HOME/Загрузки"
XDG_TEMPLATES_DIR="$HOME/.local/share/templates"
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
rm -R ~/Документы ~/Изображения ~/Музыка ~/Общедоступные ~/Шаблоны ~/Рабочий\ стол
```

### Разработка

Копируем файлы настройки:

```sh
~/Dev/environment/bin/copy-env system
```

Устанавливаем пакеты:

```sh
sudo dnf install git tig ripgrep golang redis postgresql postgresql-server postgresql-contrib
```

Устанавливаем Java:

```sh
sudo dnf install java-1.8.0-openjdk
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

Устаналиваем `node` и `yarn`:

```sh
sudo dnf install https://rpm.nodesource.com/pub_11.x/fc/28/x86_64/nodesource-release-fc28-1.noarch.rpm
sudo dnf install nodejs
sudo wget https://dl.yarnpkg.com/rpm/yarn.repo -O /etc/yum.repos.d/yarn.repo
sudo dnf install yarn
```

Устаналиваем `chruby`:

```sh
sudo dnf install https://copr-be.cloud.fedoraproject.org/results/nwallace/ruby-tools/fedora-26-x86_64/00140262-chruby/chruby-0.3.9-1.noarch.rpm
```

Собираем Ruby:

```sh
sudo dnf install gcc automake gdbm-devel libffi-devel libyaml-devel openssl-devel ncurses-devel readline-devel zlib-devel gcc-c++ libxml2 libxml2-devel libxslt libxslt-devel postgresql-devel sqlite-devel
~/Dev/environment/bin/build-ruby 2.5.3
source /usr/share/chruby/chruby.sh
chruby 2.5.3
gem install bundler
```

Устанавливаем [Helm](https://github.com/helm/helm/releases).

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

Устанавливаем Docker:

```sh
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install docker-ce
sudo groupadd docker
sudo usermod -aG docker $USER
sudo systemctl enable docker
sudo systemctl start docker
sudo curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
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
source /home/ai/.prompt/async.zsh
source /home/ai/.prompt/main.zsh
```

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
