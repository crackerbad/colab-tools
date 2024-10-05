#!/bin/bash

# Nome do script Python a ser encerrado
nome_script="jdownload_to_ucolab.py"


# Obtém o PID do processo Python com base no nome do script
pid=$(pgrep -f "$nome_script")

# Verifica se o processo está em execução
if [ -z "$pid" ]; then
    echo "O processo $nome_script não está em execução."
else
    # Processo em execução
    echo "Finalizando processo $nome_script (PID: $pid)."
    kill "$pid"
fi
