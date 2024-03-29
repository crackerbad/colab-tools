#!/bin/bash

# Nome do script Python a ser encerrado
nome_script="qbittorrent-nox"


# Obtém o PID do processo Python com base no nome do script
pid=$(pgrep -f "$nome_script")

# Verifica se o processo está em execução
if [ -z "$pid" ]; then
    echo "O processo $nome_script não está em execução."
else
    # Processo em execução
    echo "Finalizando processo $nome_script (PID: $pid)."
    kill "$pid"
    echo "Reiniciando processo $nome_script..."
    nohup qbittorrent-nox > /content/logs/qbittorrent.log 2>&1 &
fi
