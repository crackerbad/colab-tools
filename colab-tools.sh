#!/bin/sh
source /etc/env

#qbittorrent repo
sudo add-apt-repository -y ppa:qbittorrent-team/qbittorrent-stable

sudo apt-get install python3-venv -y
sudo apt-get update
mkdir "tools"
mkdir "logs"
mkdir -p "/content/downloads/jd2_downloads"
rm -r /content/sample_data
sudo apt-get -y install busybox
pip install ipywidgets

INSTALL_CRDOWNLOADER(){
	cd /content/tools
	wget "https://raw.githubusercontent.com/crackerbad/colab-tools/main/tools/crunchyroll-remuxer.sh"
	wget "https://raw.githubusercontent.com/crackerbad/colab-tools/main/tools/crunchyroll-remuxer_delayed.sh"
	wget "https://github.com/crackerbad/colab-tools/raw/main/tools/crunchyroll_start.sh"
	wget "https://github.com/anidl/multi-downloader-nx/releases/download/v5.1.0/multi-downloader-nx-linux-gui.7z" -O "multi-downloader-nx-linux-gui.7z"
	7z x "multi-downloader-nx-linux-gui.7z" && rm multi-downloader-nx-linux-gui.7z
	mv "multi-downloader-nx-linux-x64-gui" "multi-downloader-nx-ubuntu64-gui"
	cd "multi-downloader-nx-ubuntu64-gui"
	rm -r config
	wget -O config.zip "https://drive.kingvegeta.workers.dev/1:/Files/colab-tools/cr_config.zip"
	unzip config.zip && rm config.zip
	#sed -i 's/ws:\/\//wss:\/\//g' /content/tools/multi-downloader-nx-ubuntu64-gui/gui/server/build/static/js/main.77156914.js
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
	wget https://raw.githubusercontent.com/crackerbad/colab-tools/main/tools/onedrive_index.py
	wget https://github.com/crackerbad/colab-tools/raw/main/nextcloud/anitsu-downloader-linux.py -O nextcloud/anitsu-downloader-linux.py
	cd /content/
}

INSTALL_ODRIVE(){
	cd /content/tools
	"""
	git clone https://github.com/crackerbad/odrive
	pip3 install -r odrive/requirements.txt
	pip3 install selenium
	pip3 install webdriver_manager
	wget https://raw.githubusercontent.com/crackerbad/colab-tools/main/odrive/odrive-downloader.sh -O odrive/odrive-downloader.sh

	"""
	#onedrive
	wget https://drive.kingvegeta.workers.dev/1:/Files/colab-tools/pySharepointDownloader.zip
	unzip pySharepointDownloader.zip
	rm pySharepointDownloader.zip
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
	sudo apt-get install rename -y
	#mkvtoolnix
	sudo apt-get install mkvtoolnix -y
	#crc32 calculator
	sudo apt-get install libarchive-zip-perl -y
	#timeoutbypass
	wget "https://github.com/crackerbad/colab-tools/raw/main/tools/timeout_bypass.sh" -O /content/tools/timeout_bypass.sh
	#Croc Send files
	curl https://getcroc.schollz.com | bash
	#Install ttyd & nano
	sudo apt-get install nano -y
	wget -qO /usr/bin/ttyd https://github.com/tsl0922/ttyd/releases/latest/download/ttyd.x86_64
	chmod +x /usr/bin/ttyd
	nohup ttyd -W -i 127.0.0.1 -p 61803 -P 3 -t fontSize=17 bash > /content/logs/ttyd.log 2>&1 &
	#jdownloader scripts
	cd /content/tools
	mkdir jdownloader
	cd jdownloader
	pip install psutil
	wget "https://github.com/crackerbad/colab-tools/raw/refs/heads/main/jdownloader/jdownloader_installer.py"
	wget "https://github.com/crackerbad/colab-tools/raw/main/jdownloader/jdownload_to_rclone.py"
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
	mkdir -p "/content/tools/caddy"
	#OPEN-SSL
	#echo "Instalando openssl."
	#sudo apt-get install openssl -y
	#echo "baixando configuração do certificado."
	#wget "https://raw.githubusercontent.com/crackerbad/colab-tools/main/caddy/OpenSSL.cnf" -O "/content/tools/caddy/OpenSSL.cnf"
	#echo "Gerando certificado..."
	#openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout "/content/tools/caddy/localhost.key" -out "/content/tools/caddy/localhost.crt" -config "/content/tools/caddy/OpenSSL.cnf"
	#caddy
	wget -qO /usr/bin/caddy "https://caddyserver.com/api/download?os=linux&arch=amd64"
	chmod +x /usr/bin/caddy
	mkdir /content/tools/caddy
	wget "https://github.com/crackerbad/colab-tools/raw/main/caddy/Caddyfile" -O "/content/tools/caddy/Caddyfile"
	nohup caddy run --config /content/tools/caddy/Caddyfile --adapter caddyfile > /content/logs/caddy.log 2>&1 &
	#filebrowser
	wget "https://github.com/crackerbad/colab-tools/raw/main/caddy/filebrowser.db" -O "/content/tools/caddy/filebrowser.db"
	curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash
	nohup filebrowser --noauth -d "/content/tools/caddy/filebrowser.db" -r /content/ -b /home/files -p 61801 > /content/logs/filebrowser.log 2>&1 &
	#homer
	wget "https://github.com/crackerbad/colab-tools/raw/main/caddy/homer.zip"
	unzip homer.zip && rm homer.zip
}

INSTALL_QBITTORRENT() {
	#qbittorrent
	mkdir /content/tools/qbittorrent/
	wget "https://github.com/crackerbad/colab-tools/raw/main/caddy/restart_qbit.sh" -O /content/tools/qbittorrent/restart_qbit.sh
	wget -q "https://raw.githubusercontent.com/crackerbad/colab-tools/main/caddy/qb_dark.zip" -O /tmp/qb_dark.zip && 7z x /tmp/qb_dark.zip -o/content/tools/qbittorrent/ && rm /tmp/qb_dark.zip
	rm -r /content/tools/qbittorrent/__MACOSX/
	mkdir /root/.config/qBittorrent/
	wget "https://github.com/crackerbad/colab-tools/raw/main/caddy/qBittorrent.conf" -O "/root/.config/qBittorrent/qBittorrent.conf"
	#sudo apt-get -y install qbittorrent-nox
	sudo mv /usr/bin/qbittorrent-nox /usr/bin/qbittorrent-fox
	#run qbitttorent
	#nohup qbittorrent-fox > /content/logs/qbittorrent.log 2>&1 &
}

INSTALL_MAKEMKV() {
	echo "Instalando MakeMKV"
	# Instala as dependências necessárias
	sudo apt-get update
	sudo apt-get install -y build-essential pkg-config libc6-dev libssl-dev libexpat1-dev libavcodec-dev libgl1-mesa-dev qtbase5-dev zlib1g-dev

	# Baixar e descompactar o arquivo do aplicativo 1
	wget https://drive.kingvegeta.workers.dev/1:/Files/colab-tools/makemkv-bin-1.17.6.tar.gz
	tar xvzf makemkv-bin-1.17.6.tar.gz
	cd makemkv-bin-1.17.6
	rm Makefile
	wget -O Makefile "https://drive.kingvegeta.workers.dev/1:/Files/colab-tools/Makefile"

	# Configurar e compilar o aplicativo
	make

	# Instalar o aplicativo
	sudo make install

	cd ..
	# Baixar e descompactar o arquivo do aplicativo 2
	wget https://drive.kingvegeta.workers.dev/1:/Files/colab-tools/makemkv-oss-1.17.6.tar.gz
	tar xvzf makemkv-oss-1.17.6.tar.gz
	cd makemkv-oss-1.17.6

	# Configurar e compilar o aplicativo
	./configure
	make

	# Instalar o aplicativo
	sudo make install
	cd /content/

	# Deletar pastas e arquivos
	rm -f makemkv-bin-1.17.6.tar.gz makemkv-oss-1.17.6.tar.gz
	rm -rf makemkv-bin-1.17.6 makemkv-oss-1.17.6
	
	echo "Instalação do MakeMKV concluída com sucesso."
}


INSTALL_TOOLS
INSTALL_DOWNLOADERS

# Install MEGA
if [ "${GUI_INSTALL}" = "Enable" ]; then
	INSTALL_CADDY
	INSTALL_QBITTORRENT
	INSTALL_CLOUDFLARED
fi

# Install MEGA
if [ "${MEGA_INSTALL}" = "Enable" ]; then
	INSTALL_MEGA
fi

# Install Youtube-DLP
if [ "${YTDLP_INSTALL}" = "Enable" ]; then
	INSTALL_YTDLP
fi

# Install Odrive
if [ "${ODRIVE_INSTALL}" = "Enable" ]; then
	INSTALL_ODRIVE
fi

# Install Crunchyroll-Downloader
if [ "${CRDOWNLOADER_INSTALL}" = "Enable" ]; then
	INSTALL_CRDOWNLOADER
fi

# Install MAKEMKV
if [ "${MAKEMKV_INSTALL}" = "Enable" ]; then
	INSTALL_MAKEMKV
fi

echo Instalação Finalizada

