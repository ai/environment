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

* Полное имя: `Андрей Ситник`
* Имя пользователя: `ai`
* Сделать администратором

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

Удаляем GRUB:

```sh
sudo yum remove shim grub2 grub2-tools grub2-efi
sudo rm -R /boot/grub2
```

Удаляем ненужные пакеты:

```sh
sudo yum remove gedit seahorse cheese devassistant evolution evolution-ews evolution-help bijiben rhythmbox shotwell gnome-boxes gnome-documents gnome-weather empathy vinagre brasero-libs desktop-backgrounds-basic orca gnome-contacts gnome-getting-started-docs gnome-shell-extension-* libreoffice-* setroubleshoot*
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
sudo yum update
```

### 5. Настройка системы

Скопировать эту папку в `~/Dev/`.

Открываем Настройки:

* **Конфиденциальность:** включаем «Сервисы местоположения».
* **Поиск:** выключаем «Терминал» и «Центр приложений».
* **Фон:** ставим обои из этой папки.
* **Мышь и сенсорная панель:** включаем «Естественная прокрутка».
* **Энегропитание:** выключаем «Уменьшать яркость при простое»,
  ставим «Выключение экрана» в «Никогда».
* **Пользователи:** ставим аватарку из этой папки и «Автоматический вход».

Выставляем настройки клавиатуры:

```sh
dconf write /org/gnome/desktop/input-sources/xkb-options "['grp:shift_caps_switch', 'grp_led:caps', 'lv3:ralt_switch', 'misc:typo', 'nbsp:level3']"
```

В Терминале:

* Параметры → Общие: выключить «Показывать панель меню …».
* Параметры профиля → Общие: выключить «Продавать гудок».

В Nautilus:

* Параметры → Вид: включить «Помещать папки перед файлами».
* Параметры → Поведение: включить «Открыть объекты одним щелчком».

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
