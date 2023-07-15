#!/bin/sh
rm -f /content/logs/aniDL_tunnel.log
nohup argo tunnel --url localhost:3030 > /content/logs/aniDL_tunnel.log 2>&1 &
sleep 5
CRURL=$(grep -oh "https://\(.*\)trycloudflare.com" /content/logs/aniDL_tunnel.log)
sed -i "s|CRUNCHYROLL_URL|${CRURL}|" /content/homer/assets/config.yml