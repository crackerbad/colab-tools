#!/bin/bash
read -p "Delay MS: "  delaytime
read -p "Track [1 = Japanese | 2 = Portuguese] :" audiotrack

#!/bin/bash

while getopts o: flag
do
    case "${flag}" in
        o) output=${OPTARG};;
    esac
done

cd "/content/tools/multi-downloader-nx-ubuntu64-gui/videos"

for f in *.mkv; do
    # Verifica o idioma da primeira faixa de audio
    lang=$(ffprobe -v error -select_streams a:0 -show_entries stream_tags=language -of csv=p=0 "$f")

    if [ "$lang" == "jpn" ]; then
        echo "Audio primario jápones prosseguindo com alterações."
        # Se o idioma for Português, corrige e padroniza as propriedades
        mkvpropedit "$f" --edit track:s2 --set flag-forced=1 --edit track:s2 --set name="Brazilian Portuguese Forced"
        mkvmerge -o "$output/CR/$f"  --sync $audiotrack:$delaytime "$f" --track-order 0:0,0:2,0:1,0:4,0:3
    else
        # Se o idioma não for Português
        echo "Audio primario português prosseguindo com alterações."
        mkvpropedit "$f" --edit track:s1 --set flag-forced=1 --edit track:s1 --set name="Brazilian Portuguese Forced"
        mkvmerge -o "$output/CR/$f"  --sync $audiotrack:$delaytime "$f"
    fi
    # Remove o arquivo original
    rm "$f"
done

cd "/content/"
echo "Remuxing Finalizado."
