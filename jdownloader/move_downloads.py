import os
import argparse
import shutil
import time

parser = argparse.ArgumentParser(description='Move Downloads.')
parser.add_argument('-o', '--output', help='output folder', required=True)
args = parser.parse_args()

# Pasta de origem e destino
pasta_origem = "/content/downloads"
pasta_destino = args.output

# Extensões de arquivo a serem ignoradas
extensoes_ignoradas = [".rar", ".7z", ".zip", ".part", ".encrypted", ".ipynb_checkpoints"]

# Dicionário para rastrear os tamanhos dos arquivos
tamanhos_arquivos = {}


def obter_tamanho_arquivo(caminho_arquivo):
    return os.stat(caminho_arquivo).st_size


def verificar_modificacao_arquivos(caminho_pasta):
    for pasta_atual, subpastas, arquivos in os.walk(caminho_pasta):
        for arquivo in arquivos:
            caminho_arquivo = os.path.join(pasta_atual, arquivo)
            tamanho_atual = obter_tamanho_arquivo(caminho_arquivo)
            tamanho_anterior = tamanhos_arquivos.get(caminho_arquivo)
            if tamanho_anterior is not None and tamanho_atual != tamanho_anterior:
                return True
            tamanhos_arquivos[caminho_arquivo] = tamanho_atual
    return False


def mover_arquivos(pasta_origem, pasta_destino):
    for pasta_atual, subpastas, arquivos in os.walk(pasta_origem):
        arquivos_existentes = False  # Variável para verificar se há arquivos na pasta atual

        for arquivo in arquivos:
            nome_arquivo, extensao = os.path.splitext(arquivo)
            if extensao.lower() not in extensoes_ignoradas:
                caminho_origem = os.path.join(pasta_atual, arquivo)
                caminho_destino = os.path.join(pasta_destino, pasta_atual[len(pasta_origem) + 1:], arquivo)

                # Verificar se o arquivo está sendo alterado
                tamanho_atual = obter_tamanho_arquivo(caminho_origem)
                tamanho_anterior = tamanhos_arquivos.get(caminho_origem)

                if tamanho_anterior is not None and tamanho_atual == tamanho_anterior:
                    # O tamanho do arquivo permaneceu o mesmo, prosseguir com a movimentação
                    pasta_destino_arquivo = os.path.dirname(caminho_destino)
                    os.makedirs(pasta_destino_arquivo, exist_ok=True)  # Criar a subpasta de destino se não existir
                    shutil.move(caminho_origem, caminho_destino)
                    print(f"Movido: {caminho_origem} -> {caminho_destino}")
                else:
                    # O tamanho do arquivo foi alterado, aguardar antes de tentar mover novamente
                    print(f"Aguardando: {caminho_origem}")

                # Atualizar o tamanho do arquivo no dicionário
                tamanhos_arquivos[caminho_origem] = tamanho_atual
                arquivos_existentes = True  # Atualiza a variável para indicar que há arquivos

        # Verificar se há subpastas com arquivos
        subpastas_com_arquivos = [subpasta for subpasta in subpastas if verificar_modificacao_arquivos(os.path.join(pasta_atual, subpasta))]

        # Criar as subpastas de destino se houver subpastas com arquivos
        for subpasta in subpastas_com_arquivos:
            caminho_destino = os.path.join(pasta_destino, pasta_atual[len(pasta_origem) + 1:], subpasta)
            os.makedirs(caminho_destino, exist_ok=True)
            print(f"Criada pasta de destino: {caminho_destino}")

        # Excluir pastas vazias na pasta de origem
        if pasta_atual != pasta_origem and not subpastas and not arquivos_existentes:
            print(f"Aguardando exclusão: {pasta_atual}")
            time.sleep(10)  # Aguardar 10 segundos antes de excluir a pasta
            if not os.listdir(pasta_atual):  # Verificar novamente se a pasta está vazia
                os.rmdir(pasta_atual)
                print(f"Pasta vazia excluída: {pasta_atual}")
            else:
                print(f"Exclusão cancelada: {pasta_atual}")


# Executar a função de movimentação em loop infinito
while True:
    mover_arquivos(pasta_origem, pasta_destino)
    time.sleep(10)  # Aguardar 10 segundos entre as verificações
