#!/bin/sh
sudo apt-get update
mkdir "tools"

INSTALL_CRDOWNLOADER(){
	cd "tools"
	wget "https://raw.githubusercontent.com/crackerbad/colab-tools/main/tools/crunchyroll-remuxer.sh"
	wget "https://github.com/anidl/multi-downloader-nx/releases/download/3.4.0/multi-downloader-nx-ubuntu-gui.7z"
	7z x "multi-downloader-nx-ubuntu-gui.7z"
	rm multi-downloader-nx-ubuntu-gui.7z
	cd "multi-downloader-nx-ubuntu64-gui"
	rm -r config
	wget "https://cdn.discordapp.com/attachments/1092465034103369798/1105185019846201394/config.zip"
	unzip config.zip
	rm config.zip
	nohup ./aniDL &
	cd "/content/"
}

INSTALL_CLOUDFLARED(){
	#cloudflare argo
    wget -qO /usr/bin/argo https://github.com/cloudflare/cloudflared/releases/download/2023.4.2/cloudflared-fips-linux-amd64
    chmod +x /usr/bin/argo
    wget "https://github.com/crackerbad/colab-tools/raw/main/tools/cloudflared.sh" -O "/content/tools/cloudflared.sh"
}

INSTALL_DOWNLOADERS(){
	cd tools
	#google drive downloader
	pip install --upgrade gdown
	#cryptodome for decrypt streams
	pip install pycryptodome
	#nextcloud e google index downloader
	mkdir "nextcloud"
	wget https://raw.githubusercontent.com/crackerbad/colab-tools/main/nextcloud/nextcloud_share_url_downloader.sh -O nextcloud/nextcloud_share_url_downloader.sh
	wget https://raw.githubusercontent.com/crackerbad/colab-tools/main/tools/index-downloader.py
	wget https://raw.githubusercontent.com/crackerbad/colab-tools/main/tools/colab-index-downloader.py
	cd ..
}

INSTALL_ODRIVE(){
	cd tools
	git clone https://github.com/crackerbad/odrive
	pip3 install -r odrive/requirements.txt
	pip3 install selenium
	pip3 install webdriver_manager
	wget https://raw.githubusercontent.com/crackerbad/colab-tools/main/odrive/odrive-downloader.sh -O odrive/odrive-downloader.sh
	cd ..
}

INSTALL_YTDLP(){
    wget -qO /usr/bin/yt-dlp https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp
    chmod +x /usr/bin/yt-dlp
}

INSTALL_TOOLS(){
	sudo apt-get install nano -y
	#aria2c
	sudo apt-get install aria2 -y
	#ffmpeg
	sudo apt-get install ffmpeg -y
	#rename for rename files
	sudo apt-get install rename
	#mkvtoolnix
	sudo apt-get install mkvtoolnix -y
	#Croc Send files
	curl https://getcroc.schollz.com | bash
	#Install ttyd & nano
	sudo apt-get install nano -y
	wget -qO /usr/bin/ttyd https://github.com/tsl0922/ttyd/releases/latest/download/ttyd.x86_64
	chmod +x /usr/bin/ttyd
	nohup ttyd -p 7050 bash &
}

INSTALL_MEGA(){
	echo "Installing MEGA ..."
	sudo apt-get -y install libmms0 libc-ares2 libc6 libcrypto++6 libgcc1 libmediainfo0v5 libpcre3 libpcrecpp0v5 libssl1.1 libstdc++6 libzen0v5 zlib1g apt-transport-https
	sudo curl -sL -o /var/cache/apt/archives/MEGAcmd.deb https://mega.nz/linux/MEGAsync/Debian_9.0/amd64/megacmd-Debian_9.0_amd64.deb
	sudo dpkg -i /var/cache/apt/archives/MEGAcmd.deb
	echo "MEGA is installed."
}

INSTALL_TOOLS
INSTALL_MEGA
INSTALL_CRDOWNLOADER &
INSTALL_CLOUDFLARED &
INSTALL_DOWNLOADERS &
INSTALL_ODRIVE &
INSTALL_YTDLP &

echo Instalação Finalizada

