import os
import re
import requests
import subprocess
import argparse

parser = argparse.ArgumentParser(description='Index Downloader.')
parser.add_argument('-i', '--index', help='index url', required=True)
parser.add_argument('-o', '--output', help='output folder (optional)', required=False)
args = parser.parse_args()

# Novo URL fornecido
input_url = args.index

print(f"Procurando Arquivos em : {input_url}\n")

# Expressão regular para encontrar URLs com "download?id="
url_pattern = re.compile(r'https?://[^/]+/download/\?id=[\w\d]+')

# Faz uma solicitação HTTP para o URL fornecido
try:
    response = requests.get(input_url)
    response.raise_for_status()  # Verifica se a solicitação foi bem-sucedida
    html_content = response.text

    # Encontra todas as URLs correspondentes ao padrão
    download_links = url_pattern.findall(html_content)

    # Remove URLs duplicadas usando um conjunto (set)
    unique_download_links = set(download_links)

    # Arquivo para armazenar os URLs únicos
    output_filename = "download_onedrive_links.txt"

    # Abre o arquivo de saída na pasta atual e escreve as URLs únicas completas
    with open(output_filename, 'w') as output_file:
        for url in unique_download_links:
            output_file.write(url + '\n')

    print(f"{len(unique_download_links)} arquivos foram encontrados e salvos em {output_filename}.\n")
    print("Iniciando Download...\n")

    # Função para fazer download dos URLs usando aria2c na subpasta "Downloads"
    def download_with_aria2c(url_file):
        try:
            OUTPUT_DIR = args.output if args.output else "Downloads"
            subprocess.run(["aria2c", "--human-readable=true", "--download-result=full", "--file-allocation=none", "-i", url_file, "-d", OUTPUT_DIR])
            print("\nDownload concluído com sucesso usando aria2c.")
            # Exclui o arquivo de texto com as URLs após o download ser concluído
            os.remove(url_file)
        except Exception as e:
            print(f"Erro ao fazer o download com aria2c: {e}")

    download_with_aria2c(output_filename)

except requests.exceptions.RequestException as e:
    print(f"Erro ao fazer a solicitação HTTP: {e}")
