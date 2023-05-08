#!/bin/bash

while getopts o: flag
do
    case "${flag}" in
        o) output=${OPTARG};;
    esac
done
cd "/content/tools/multi-downloader-nx-ubuntu64-gui/videos"
for f in *.mkv; do
    #corrige e padroniza propriedades
    mkvpropedit "$f" --edit track:a1 --set name="Japanese" \
    --edit track:a2 --set flag-default=1 --edit track:a1 --set flag-default=0 \
    --edit track:s2 --set flag-forced=1 --edit track:s2 --set name="Brazilian Portuguese Forced"
    #salva na pasta de saida
    mkvmerge -o "$output/CR/$f" "$f" --track-order 0:0,0:2,0:1,0:4,0:3     
    rm "$f"
done
cd "/content/"
echo "Remuxing Finalizado."