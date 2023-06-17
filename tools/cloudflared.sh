#!/bin/bash
while getopts p: flag
do
    case "${flag}" in
        p) port=${OPTARG};;
    esac
done

#source /etc/env
#export $(sed '/^#/d' /etc/env | cut -d= -f1)
echo "Cloudflared Argo Tunnel port $port will be ready in one minute"

killall argo 2>/dev/null
cd /content/tools/
rm -f nohup.out
nohup argo tunnel --url localhost:$port &
sleep 5

URL=$(grep -oh "https://\(.*\)trycloudflare.com" nohup.out)

echo
echo Argo Tunnel Iniciado em : ${URL}
rm -f nohup.out
#tail -f
