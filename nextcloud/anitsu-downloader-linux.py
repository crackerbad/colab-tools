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

def should_skip_download(folder_name):
    # Lista de palavras proibidas nos diretórios
    forbidden_words = ["Desenhos", "Quadrinhos", "Séries", "#TEMP", "0-9", "Letra"]
    
    # Decodifica o nome da pasta para torná-lo legível
    decoded_folder_name = decode_folder_name(folder_name)
    
    # Verifica se o nome da pasta está vazio ou é a raiz
    if not decoded_folder_name or decoded_folder_name == "/":
        return True
    
    # Obtém o nome da última subpasta
    subfolders = decoded_folder_name.split("/")
    last_folder_name = subfolders[-1] if subfolders[-1] else subfolders[-2]  # Se a última subpasta for vazia, pegue a anterior
    
    # Remove barras extras e codificação
    last_folder_name_stripped = last_folder_name.replace("%2F", "/")
    
    # Verifica se o nome da última subpasta contém a palavra "Animes"
    if last_folder_name_stripped == "Animes":
        return True
    
    # Verifica se o nome da última subpasta contém alguma palavra proibida
    return any(word in last_folder_name_stripped for word in forbidden_words)


def check_rclone_availability():
    # Verifica se o rclone está disponível
    try:
        subprocess.run(["rclone", "version"], check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    except FileNotFoundError:
        print("O rclone não foi encontrado. Certifique-se de instalá-lo e configurá-lo corretamente.")
        exit()

def download_content(url):
    try:
        # Extrai o usuário e o nome da pasta da URL
        user, folder_name = extract_user_and_folder_name(url)
        
        # Extrai a URL base do WebDAV da URL
        webdav_base_url = extract_webdav_url(url)

        # Verifica se devemos pular o download
        if should_skip_download(folder_name):
            raise ValueError("Diretório proibido. O download será ignorado.")

        # Cria a configuração WebDAV com rclone
        config_command = [
            "rclone",
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
            "rclone",
            "copy",
            "anitsu:" + decoded_folder_name,  # Caminho de origem
            "./" + target_folder_name,  # Caminho de destino
            "--no-check-certificate",  # Desativa a verificação do certificado TLS
            "--transfers", "1",  # Limite de 1 transferência simultânea
            "--local-no-sparse",  # Não use sparse files localmente
            "-vP"   # Verifica o progresso de transferência
        ]
        subprocess.run(download_command, check=True)
    except ValueError as e:
        print(str(e))
    finally:
        # Exclui a configuração anitsu: do rclone
        subprocess.run(["rclone", "config", "delete", "anitsu"], check=False)

# Verifica a disponibilidade do rclone
check_rclone_availability()

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
