import os
import argparse
import subprocess
import time
import random
import psutil

def generate_random_service_account_number():
    random_number = random.randint(1, 50)
    return random_number

def generate_service_account_filepath(number):
    filename = f"{number:03}.json"
    filepath = f"/root/.config/rclone/accounts/{filename}"
    return filepath

parser = argparse.ArgumentParser(description='Rclone Upload Downloads.')
parser.add_argument('-o', '--output', help='output folder', required=True)
args = parser.parse_args()

# Pasta de origem e destino
pasta_origem = "/content/downloads/jd2_downloads"
pasta_destino = args.output

# Extensões de arquivo a serem ignoradas
extensoes_ignoradas = [".rar", ".7z", ".zip", ".aria2", ".part", ".encrypted", ".py", ".sh", ".partial", ".ts", r".!qB"]

# Dicionário para rastrear os tamanhos dos arquivos
tamanhos_arquivos = {}


def obter_tamanho_arquivo(caminho_arquivo):
    return os.stat(caminho_arquivo).st_size


def verificar_modificacao_arquivos(caminho_pasta):
    for pasta_atual, subpastas, arquivos in os.walk(caminho_pasta):
        for arquivo in arquivos:
            caminho_arquivo = os.path.join(pasta_atual, arquivo)
            
            # Verificar se o arquivo está em uso por algum processo
            for proc in psutil.process_iter(['name']):
                try:
                    arquivos_abertos = proc.open_files()
                    for arquivo_aberto in arquivos_abertos:
                        if arquivo_aberto.path == caminho_arquivo:
                            return True
                except (psutil.NoSuchProcess, psutil.AccessDenied):
                    pass
    
    return False

def mover_arquivos(pasta_origem, pasta_destino):
    for pasta_atual, subpastas, arquivos in os.walk(pasta_origem):
        arquivos_existentes = False  # Variável para verificar se há arquivos na pasta atual

        for arquivo in arquivos:
            nome_arquivo, extensao = os.path.splitext(arquivo)
            if extensao.lower() not in extensoes_ignoradas:
                caminho_origem = os.path.join(pasta_atual, arquivo)
                caminho_relativo = os.path.relpath(caminho_origem, pasta_origem)
                caminho_destino = os.path.join(pasta_destino, caminho_relativo)

                # Verificar se o arquivo está sendo alterado
                tamanho_atual = obter_tamanho_arquivo(caminho_origem)
                tamanho_anterior = tamanhos_arquivos.get(caminho_origem)

                if tamanho_anterior is not None and tamanho_atual == tamanho_anterior:
                    random_number = generate_random_service_account_number()
                    service_account_file = generate_service_account_filepath(random_number)
                    time.sleep(2)
                    # O tamanho do arquivo permaneceu o mesmo, prosseguir com a movimentação
                    subprocess.run(['cloner', 
                                    'copy', 
                                    f"alias:{caminho_origem}", 
                                    os.path.dirname(caminho_destino), 
                                    '--drive-chunk-size', 
                                    '128M', 
                                    f"--drive-service-account-file={service_account_file}", 
                                    '--retries', 
                                    '100', 
                                    "--log-file=/content/logs/rclone_jdownloader.log"])

                    # Após a cópia, excluir o arquivo da origem
                    os.remove(caminho_origem)

                    print(f"Movido: {caminho_origem} -> {caminho_destino}")
                else:
                    # O tamanho do arquivo foi alterado, aguardar antes de tentar mover novamente
                    print(f"Aguardando: {caminho_origem}")

                # Atualizar o tamanho do arquivo no dicionário
                tamanhos_arquivos[caminho_origem] = tamanho_atual
                arquivos_existentes = True  # Atualiza a variável para indicar que há arquivos

        # Verificar se há subpastas com arquivos
        subpastas_com_arquivos = [subpasta for subpasta in subpastas if verificar_modificacao_arquivos(os.path.join(pasta_atual, subpasta))]

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
    time.sleep(5)  # Aguardar 10 segundos entre as verificações
