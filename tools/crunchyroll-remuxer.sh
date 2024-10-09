#!/bin/bash

while getopts o: flag
do
    case "${flag}" in
        o) output=${OPTARG};;
    esac
done

cd "/content/tools/multi-downloader-nx-ubuntu64-gui/videos"

for f in *.mkv; do
    # Substitui espaços por pontos no nome do arquivo
    new_f=$(echo "$f" | tr ' ' '.')

    # Verifica o idioma da primeira faixa de áudio
    lang=$(ffprobe -v error -select_streams a:0 -show_entries stream_tags=language -of csv=p=0 "$f")

    # Remove a extensão ".mkv" e a parte "E${episode}" para o nome da pasta
    folder_name=$(echo "$new_f" | sed -E 's/(.*)(E[0-9]+)(.*)\.mkv/\1\3/')

    # Cria o diretório baseado no nome extraído (se não existir)
    mkdir -p "$output/$folder_name"

    if [ "$lang" == "jpn" ]; then
        echo "Áudio primário japonês, prosseguindo com alterações."
        # Se o idioma for Japonês, corrige e padroniza as propriedades
        mkvpropedit "$f" --edit track:s2 --set flag-forced=1 --edit track:s2 --set name="Brazilian Portuguese Forced"
        mkvmerge -o "$output/$folder_name/$new_f" "$f" --track-order 0:0,0:2,0:1,0:4,0:3
    else
        echo "Áudio primário não é japonês, prosseguindo com alterações."
        # Se o idioma não for japonês, ajusta o arquivo
        mkvpropedit "$f" --edit track:s1 --set flag-forced=1 --edit track:s1 --set name="Brazilian Portuguese Forced"
        mkvmerge -o "$output/$folder_name/$new_f" "$f"
    fi
    # Remove o arquivo original
    rm "$f"
done

cd "/content/"
echo "Remuxing Finalizado."
