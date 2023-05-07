#!/bin/bash

#source /etc/env
#export $(sed '/^#/d' /etc/env | cut -d= -f1)
echo "Cloudflared Argo Tunnel will be ready in one minute"

killall argo 2>/dev/null
cd /content/tools/
rm -f nohup.out
nohup argo tunnel --url http://localhost:3000 &
sleep 5

URL=$(grep -oh "https://\(.*\)trycloudflare.com" nohup.out)

echo Argo Tunnel Iniciado em : ${URL}
#tail -f
