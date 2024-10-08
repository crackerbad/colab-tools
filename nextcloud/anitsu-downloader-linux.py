import subprocess
import urllib.parse
import re
import os
import argparse

def decode_folder_name(folder_name):
    return urllib.parse.unquote(folder_name)

def extract_user_and_folder_name(url):
    # Usa expressão regular para extrair o usuário entre /s/ e ?path=
    match = re.search(r'/s/([^/?]+)\?path=(.*)', url)
    if match:
        user = match.group(1)
        folder_name = match.group(2)
        return user, folder_name
    else:
        raise ValueError("URL inválida!")

def extract_webdav_url(url):
    # Extrai a URL base do WebDAV da URL completa
    base_url_match = re.search(r'(https://.*?/nextcloud)/s/[^/]+\?path=', url)
    if base_url_match:
        return base_url_match.group(1) + "/public.php/webdav/"
    else:
        raise ValueError("URL inválida!")
        
def check_ucolab_availability():
    # Verifica se o ucolab está disponível
    try:
        subprocess.run(["ucolab", "version"], check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    except FileNotFoundError:
        print("O ucolab não foi encontrado. Certifique-se de instalá-lo e configurá-lo corretamente.")
        exit()

def download_content(url):
    try:
        # Extrai o usuário e o nome da pasta da URL
        user, folder_name = extract_user_and_folder_name(url)
        
        # Extrai a URL base do WebDAV da URL
        webdav_base_url = extract_webdav_url(url)

        # Cria a configuração WebDAV com ucolab
        config_command = [
            "ucolab",
            "config",
            "create",
            "anitsu",
            "webdav",
            "url=" + webdav_base_url,
            "user=" + user,
        ]
        subprocess.run(config_command, check=True)

        # Decodifica o nome da pasta
        decoded_folder_name = decode_folder_name(folder_name)
        
        # Extrai o nome da última subpasta como o nome da pasta de destino
        target_folder_name = decoded_folder_name.split("/")[-1]

        # Baixa o conteúdo da pasta
        download_command = [
            "ucolab",
            "copy",
            "anitsu:" + decoded_folder_name,  # Caminho de origem
            "./" + target_folder_name,  # Caminho de destino
            "--no-check-certificate",  # Desativa a verificação do certificado TLS
            "--transfers", "4",  # Limite de 1 transferência simultânea
            "--local-no-sparse",  # Não use sparse files localmente
            "-vP"   # Verifica o progresso de transferência
        ]
        subprocess.run(download_command, check=True)
    except ValueError as e:
        print(str(e))
    finally:
        # Exclui a configuração anitsu: do ucolab
        subprocess.run(["ucolab", "config", "delete", "anitsu"], check=False)

# Verifica a disponibilidade do ucolab
check_ucolab_availability()

# Configurar o parser de argumentos
parser = argparse.ArgumentParser(description='Baixar conteúdo do Anitsu.')
parser.add_argument('-u', '--url', help='URL de download')

# Analisar os argumentos da linha de comando
args = parser.parse_args()

# Verificar se foi fornecida uma URL
if args.url:
    download_content(args.url)
else:
    print("Nenhuma URL fornecida.")
