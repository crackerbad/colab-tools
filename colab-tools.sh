#!/bin/sh
source /etc/env

sudo apt-get update
mkdir "tools"
mkdir "logs"
rm -r /content/sample_data

INSTALL_CRDOWNLOADER(){
	cd /content/tools
	wget "https://raw.githubusercontent.com/crackerbad/colab-tools/main/tools/crunchyroll-remuxer.sh"
	wget "https://raw.githubusercontent.com/crackerbad/colab-tools/main/tools/crunchyroll-remuxer_delayed.sh"
	wget "https://github.com/anidl/multi-downloader-nx/releases/download/3.4.0/multi-downloader-nx-ubuntu-gui.7z"
	7z x "multi-downloader-nx-ubuntu-gui.7z"
	rm multi-downloader-nx-ubuntu-gui.7z
	cd "multi-downloader-nx-ubuntu64-gui"
	rm -r config
	wget "https://cdn.discordapp.com/attachments/1092465034103369798/1105185019846201394/config.zip"
	unzip config.zip
	rm config.zip
	nohup ./aniDL > /content/logs/aniDL.log 2>&1 &
	cd "/content/"
}

INSTALL_CLOUDFLARED(){
	#cloudflare argo
	wget -qO /usr/bin/argo https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64
	chmod +x /usr/bin/argo
    wget "https://github.com/crackerbad/colab-tools/raw/main/tools/cloudflared.sh" -O "/content/tools/cloudflared.sh"
    bash /content/tools/cloudflared.sh &
}

INSTALL_DOWNLOADERS(){
	cd /content/tools
	#google drive downloader
	pip install --upgrade gdown
	#cryptodome for decrypt streams
	pip install pycryptodome
	#nextcloud e google index downloader
	mkdir "nextcloud"
	wget https://raw.githubusercontent.com/crackerbad/colab-tools/main/nextcloud/nextcloud_share_url_downloader.sh -O nextcloud/nextcloud_share_url_downloader.sh
	wget https://raw.githubusercontent.com/crackerbad/colab-tools/main/tools/index-downloader.py
	wget https://raw.githubusercontent.com/crackerbad/colab-tools/main/tools/colab-index-downloader.py
	cd /content/
}

INSTALL_ODRIVE(){
	cd /content/tools
	git clone https://github.com/crackerbad/odrive
	pip3 install -r odrive/requirements.txt
	pip3 install selenium
	pip3 install webdriver_manager
	wget https://raw.githubusercontent.com/crackerbad/colab-tools/main/odrive/odrive-downloader.sh -O odrive/odrive-downloader.sh
	cd /content/
}

INSTALL_YTDLP(){
    wget -qO /usr/bin/yt-dlp https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp
    chmod +x /usr/bin/yt-dlp
}

INSTALL_TOOLS(){
	#rclone
	curl https://rclone.org/install.sh | sudo bash
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
	nohup ttyd -i 127.0.0.1 -p 61803 -P 3 -t fontSize=17 bash > /content/logs/ttyd.log 2>&1 &
	#jdownloader scripts
	cd /content/tools
	mkdir jdownloader
	cd jdownloader
	wget "https://github.com/crackerbad/colab-tools/raw/main/jdownloader/move_downloads.py"
	wget "https://github.com/crackerbad/colab-tools/raw/main/jdownloader/restart_backup.sh"
	wget "https://github.com/crackerbad/colab-tools/raw/main/jdownloader/terminate_backup.sh"
	cd /content/
}

INSTALL_MEGA(){
	echo "Installing MEGA ..."
	sudo apt-get -y install libmms0 libc-ares2 libc6 libcrypto++6 libgcc1 libmediainfo0v5 libpcre3 libpcrecpp0v5 libssl1.1 libstdc++6 libzen0v5 zlib1g apt-transport-https
	sudo curl -sL -o /var/cache/apt/archives/MEGAcmd.deb https://mega.nz/linux/MEGAsync/Debian_9.0/amd64/megacmd-Debian_9.0_amd64.deb
	sudo dpkg -i /var/cache/apt/archives/MEGAcmd.deb
	echo "MEGA is installed."
}

INSTALL_CADDY(){
	#caddy
	wget -qO /usr/bin/caddy "https://caddyserver.com/api/download?os=linux&arch=amd64"
	chmod +x /usr/bin/caddy
	mkdir /content/tools/caddy
	wget "https://github.com/crackerbad/colab-tools/raw/main/caddy/Caddyfile" -O "/content/tools/caddy/Caddyfile"
	nohup caddy run --config /content/tools/caddy/Caddyfile --adapter caddyfile > /content/logs/caddy.log 2>&1 &
	#filebrowser
	wget "https://github.com/crackerbad/colab-tools/raw/main/caddy/filebrowser.db" -O "/content/tools/caddy/filebrowser.db"
	curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash
	nohup filebrowser -d "/content/tools/caddy/filebrowser.db" -r /content/ -b /home/files -p 61801 > /content/logs/filebrowser.log 2>&1 &
	#homer
	wget "https://github.com/crackerbad/colab-tools/raw/main/caddy/homer.zip"
	unzip homer.zip
	rm homer.zip
	#rm "/content/homer/assets/config.yml"
	#wget "https://github.com/crackerbad/colab-tools/raw/main/caddy/config.yml" -O "/content/homer/assets/config.yml"

	#qbittorrent
	wget "https://github.com/c0re100/qBittorrent-Enhanced-Edition/releases/download/release-4.5.3.10/qbittorrent-enhanced-nox_x86_64-linux-musl_static.zip"
	unzip "qbittorrent-enhanced-nox_x86_64-linux-musl_static.zip"
	rm "qbittorrent-enhanced-nox_x86_64-linux-musl_static.zip"
	mkdir /content/tools/qBittorrent
	mv /content/qbittorrent-nox /content/tools/qBittorrent/
	chmod 777 /content/tools/qBittorrent/qbittorrent-nox
	mkdir "/root/.config/qBittorent"
	wget "https://github.com/crackerbad/colab-tools/raw/main/caddy/qBittorrent.conf" -O "/root/.config/qBittorrent/qBittorrent.conf"
	nohup /content/tools/qBittorrent/qbittorrent-nox > /content/logs/qbittorent.log 2>&1 &
}


# Install Crunchyroll-Downloader
if [ "${CRDOWNLOADER_INSTALL}" = "Enable" ]; then
	INSTALL_CRDOWNLOADER &
fi

# Install MEGA
if [ "${MEGA_INSTALL}" = "Enable" ]; then
	INSTALL_MEGA
fi

# Install Youtube-DLP
if [ "${YTDLP_INSTALL}" = "Enable" ]; then
	INSTALL_YTDLP &
fi

# Install Odrive
if [ "${ODRIVE_INSTALL}" = "Enable" ]; then
	INSTALL_ODRIVE &
fi

INSTALL_TOOLS
INSTALL_CLOUDFLARED
INSTALL_DOWNLOADERS
INSTALL_CADDY

echo Instalação Finalizada

