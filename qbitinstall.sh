#!/bin/sh
sudo apt-get install qbittorrent-nox -y
sudo add-apt-repository ppa:jcfp/nobetas -y
sudo apt-get update && sudo apt-get dist-upgrade -y
sudo apt-get install sabnzbdplus -y
#curl https://rclone.org/install.sh | sudo bash
curl https://drive.kingvegeta.workers.dev/1:/Files/telegram/gclone-v1.66.0-mod1.6.1-linux-amd64.deb
dpkg -i gclone-v1.66.0-mod1.6.1-linux-amd64.deb
rm gclone-v1.66.0-mod1.6.1-linux-amd64.deb
mkdir -p /content/downloads
mkdir -p /content/logs
ln -s /usr/bin/fusermount /usr/bin/fusermount3
rclone --config /content/rclone.conf mount onedrive:Telegram /content/downloads --vfs-cache-mode writes --vfs-cache-max-size 50G --buffer-size 32M --transfers 16 --checkers 16 > /content/logs/onedrive.log 2>&1 &
git clone https://github.com/meganz/sdk.git --depth=1 -b v4.8.0 /home/sdk \
    && cd /home/sdk && rm -rf .git \
    && autoupdate -fIv && ./autogen.sh \
    && ./configure --disable-silent-rules --enable-python --with-sodium --disable-examples \
    && make -j$(nproc --all) \
    && cd bindings/python/ && python3 setup.py bdist_wheel \
    && cd dist && ls && pip3 install --no-cache-dir megasdk-*.whl

mkdir -p -m 666 /JDownloader/libs
apt-get install openjdk-8-jre-headless -qq -y
wget -q http://installer.jdownloader.org/JDownloader.jar -O /JDownloader/JDownloader.jar
java -jar /JDownloader/JDownloader.jar -norestart -h
wget -q https://shirooo39.github.io/MiXLab/resources/packages/jdownloader/sevenzipjbinding1509.jar -O /JDownloader/libs/sevenzipjbinding1509.jar
wget -q https://shirooo39.github.io/MiXLab/resources/packages/jdownloader/sevenzipjbinding1509Linux.jar -O /JDownloader/libs/sevenzipjbinding1509Linux.jar
