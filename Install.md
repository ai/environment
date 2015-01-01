# Процесс разворачивания окружения

## Установить Федору

Скачать образ:

```sh
wget http://download.fedoraproject.org/pub/fedora/linux/releases/21/Workstation/x86_64/iso/Fedora-Live-Workstation-x86_64-21-5.iso
```

Записать его на USB-флешку:

```sh
sudo yum remove liveusb-creator
sudo liveusb-creator
```
