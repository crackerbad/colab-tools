#!/bin/sh
sudo apt-get update

#odrive
git clone https://github.com/crackerbad/odrive
pip3 install -r odrive/requirements.txt
pip3 install selenium
pip3 install webdriver_manager
wget https://raw.githubusercontent.com/crackerbad/colab-tools/main/odrive/odrive-downloader.sh -O odrive/odrive-downloader.sh

#nextcloud e google index downloader
mkdir "nextcloud"
wget https://raw.githubusercontent.com/crackerbad/colab-tools/main/nextcloud/nextcloud_share_url_downloader.sh -O nextcloud/nextcloud_share_url_downloader.sh
wget https://raw.githubusercontent.com/crackerbad/colab-tools/main/nextcloud/index-downloader.py -O nextcloud/index-downloader.py

#Croc Send files
curl https://getcroc.schollz.com | bash

#youtube-dlp
sudo wget https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -O /usr/local/bin/yt-dlp
sudo chmod a+rx /usr/local/bin/yt-dlp

#rename for rename files
sudo apt-get install rename

#cryptodome for decrypt streams
pip install pycryptodome

#google drive downloader
pip install gdown
pip install --upgrade gdown

#ffmpeg
sudo apt-get install ffmpeg -y

#mkvtoolnix
sudo apt-get install mkvtoolnix -y

#aria2c
sudo apt-get install aria2 -y

#aniDL
wget "https://github.com/anidl/multi-downloader-nx/releases/download/3.4.0/multi-downloader-nx-ubuntu-gui.7z"
mkdir cr-downloader
7z e -y "multi-downloader-nx-ubuntu-gui.7z" -o/content/cr-downloader/
cd cr-downloader
wget "https://cdn.discordapp.com/attachments/1092465034103369798/1104601009357070387/config.zip"
unzip config.zip
cd ..
./cr-downloader/aniDL &

echo Instalação Finalizada

