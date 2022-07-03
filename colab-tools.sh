#!/bin/sh
sudo apt-get update

#npm torrent client
npm install -g npm
npm i torrent -g

#Croc Send files
curl https://getcroc.schollz.com | bash

#youtube-dlp
sudo wget https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -O /usr/local/bin/yt-dlp
sudo chmod a+rx /usr/local/bin/yt-dlp

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

echo Instalação Finalizada

