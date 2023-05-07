#!/bin/sh
sudo apt-get update

INSTALL_ODRIVE(){
	git clone https://github.com/crackerbad/odrive
	pip3 install -r odrive/requirements.txt
	pip3 install selenium
	pip3 install webdriver_manager
	wget https://raw.githubusercontent.com/crackerbad/colab-tools/main/odrive/odrive-downloader.sh -O odrive/odrive-downloader.sh
}

INSTALL_DOWNLOADERS(){
	#google drive downloader
	pip install --upgrade gdown
	#cryptodome for decrypt streams
	pip install pycryptodome
	#nextcloud e google index downloader
	mkdir "nextcloud"
	wget https://raw.githubusercontent.com/crackerbad/colab-tools/main/nextcloud/nextcloud_share_url_downloader.sh -O nextcloud/nextcloud_share_url_downloader.sh
	wget https://raw.githubusercontent.com/crackerbad/colab-tools/main/nextcloud/index-downloader.py -O nextcloud/index-downloader.py
	#aria2c
	sudo apt-get install aria2 -y
}

INSTALL_TOOLS(){
	#ffmpeg
	sudo apt-get install ffmpeg -y
	#rename for rename files
	sudo apt-get install rename
	#mkvtoolnix
	sudo apt-get install mkvtoolnix -y
	#Croc Send files
	#curl https://getcroc.schollz.com | bash
}

INSTALL_YTDLP(){
    wget -qO /usr/bin/yt-dlp https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp
    chmod +x /usr/bin/yt-dlp
}


INSTALL_CRDOWNLOADER(){
	wget "https://github.com/anidl/multi-downloader-nx/releases/download/3.4.0/multi-downloader-nx-ubuntu-gui.7z"
	mkdir cr-downloader
	7z e -y "multi-downloader-nx-ubuntu-gui.7z" -o/content/cr-downloader/
	cd cr-downloader
	wget "https://cdn.discordapp.com/attachments/1092465034103369798/1104601009357070387/config.zip"
	unzip config.zip
	cd ..
}

INSTALL_CLOUDFLARED() {
	#cloudflare argo
    wget -qO /usr/bin/argo https://github.com/cloudflare/cloudflared/releases/download/2023.4.2/cloudflared-fips-linux-amd64
    chmod +x /usr/bin/argo
    wget https://github.com/crackerbad/colab-tools/raw/main/tools/cloudflared.sh -O /workdir/cloudflared.sh
}

INSTALL_ODRIVE &
INSTALL_DOWNLOADERS &
INSTALL_TOOLS &
INSTALL_YTDLP &
INSTALL_CRDOWNLOADER &
INSTALL_CLOUDFLARED &

echo Instalação Finalizada

