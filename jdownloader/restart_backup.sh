#!/bin/bash

# Nome do script Python a ser encerrado
nome_script="move_downloads.py"


# Obtém o PID do processo Python com base no nome do script
pid=$(pgrep -f "$nome_script")

# Verifica se o processo está em execução
if [ -z "$pid" ]; then
    echo "O processo $nome_script não está em execução."
    echo "Inicializando Sistema de Backup..."
    nohup python /content/tools/jdownloader/move_downloads.py -o "$SAVE_FOLDER" > /content/logs/JDMove_Downloads.log 2>&1 &
else
    # Processo em execução
    echo "Processo $nome_script (PID: $pid) já está em execução."
    kill "$pid"
    nohup python /content/tools/jdownloader/move_downloads.py -o "$SAVE_FOLDER" > /content/logs/JDMove_Downloads.log 2>&1 &
    echo "Sistema de Backup Reiniciado."
fi
