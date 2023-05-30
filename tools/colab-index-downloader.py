import argparse
import requests
import base64
import json
import urllib
import os
import subprocess
import time


if os.name == 'posix':
    list_folder = '/home/'
else:
    list_folder = os.getcwd()

list_file = list_folder + '/download_list.txt'

print("Starting Index Downloader...\n")

try:
    os.remove(list_file)
except FileNotFoundError:
    pass

time.sleep(1)

page_one_loaded = False
next_page = False
next_page_token = ""

parser = argparse.ArgumentParser(description='Index Downloader.')
parser.add_argument('-i', '--index', help='index link', required=True)
parser.add_argument('-o', '--output', help='output folder (optional)', required=False)
parser.add_argument('-u', '--user', help='index username (optional)', required=False)
parser.add_argument('-p', '--password', help='index password (optional)', required=False)
args = parser.parse_args()

OUTPUT_DIR = args.output if args.output else "Download"
isExist = os.path.exists(OUTPUT_DIR)
if not isExist:
    os.makedirs(OUTPUT_DIR)
    print(f"\n{OUTPUT_DIR} directory created!")


def authorization_token(username, password):
    user_pass = f"{username}:{password}"
    return f"Basic {base64.b64encode(user_pass.encode()).decode()}"


def decrypt(string):
    return base64.b64decode(string[::-1][24:-20]).decode("utf-8")


def func(payload_input, url, username, password):
    global page_one_loaded
    global next_page
    global next_page_token

    url = f"{url}/" if url[-1] != "/" else url

    try:
        headers = {"authorization": authorization_token(username, password)}
    except:
        return "username/password combination is wrong"

    encrypted_response = requests.post(url, data=payload_input, headers=headers)
    if encrypted_response.status_code == 401:
        return "username/password combination is wrong"

    try:
        decrypted_response = json.loads(decrypt(encrypted_response.text))
    except:
        return "something went wrong. check index link/username/password field again"

    page_token = decrypted_response["nextPageToken"]
    if page_token is None:
        next_page = False
    else:
        next_page = True
        next_page_token = page_token

    if list(decrypted_response.get("data").keys())[0] != "error":
        file_length = len(decrypted_response["data"]["files"])
        existing_links = set()

        for i in range(file_length):
            files_type = decrypted_response["data"]["files"][i]["mimeType"]

            if not page_one_loaded:
                print("Loading Page: 1")
                time.sleep(1)
                page_one_loaded = True

            if files_type != "application/vnd.google-apps.folder":
                files_name = decrypted_response["data"]["files"][i]["name"]
                direct_download_link = url + urllib.parse.quote(files_name)
                existing_links.add(direct_download_link)

        save_download_links_to_file(existing_links, list_file)

    return ""


def save_download_links_to_file(download_links, file_path):
    if not os.path.isfile(file_path):
        open(file_path, 'w').close()

    with open(file_path, "a") as txt_file:
        for link in download_links:
            txt_file.write(link + "\n")


def remove_duplicates(file_path):
    global page_one_loaded
    if not os.path.isfile(file_path):
        print(f"File '{file_path}' not found.")
        return

    with open(file_path, "r") as txt_file:
        lines = txt_file.read().splitlines()

    unique_links = set(lines)

    with open(file_path, "w") as txt_file:
        for link in unique_links:
            txt_file.write(link + "\n")

    original_count = len(lines)
    removed_count = original_count - len(unique_links)
    final_count = len(unique_links)

    #print(f"Original links count: {original_count}")
    #print(f"Removed duplicate links: {removed_count}")
    if removed_count < final_count * 0.5:
        print(f"Total files found: {final_count}")

    if removed_count > final_count * 0.5:
        print("\nError encountered, trying again. Please wait!")
        time.sleep(2)
        os.remove(list_file)
        page_one_loaded = False
        main(url=index_link, username=username, password=password)
        remove_duplicates(list_file)


def main(url, username="none", password="none"):
    x = 0
    payload = {"page_token": next_page_token, "page_index": x}
    print(f"\n\nGenerating Download Links from: {url}\n\n")
    print(func(payload, url, username, password))
    while next_page:
        payload = {"page_token": next_page_token, "page_index": x}
        print(f"Loading Page: {x + 2}")
        time.sleep(1)
        print(func(payload, url, username, password))
        x += 1


def download_files_from_list():
    try:
        print("\nStarting Downloads with aria2c...")
        list_file = list_folder + '/download_list.txt'
        # subprocess.run(['aria2c', "--dir=" + OUTPUT_DIR, "--input-file=" + list_file, "--max-concurrent-downloads=3",
        #    "--connect-timeout=60", "--max-connection-per-server=8", "--continue=true", "--split=8", "--min-split-size=1M",
        #    "--human-readable=true", "--download-result=full", "--file-allocation=none", "--auto-save-interval=0"])
        # if os.path.exists(list_file):
        #    os.remove(list_file)
        return True
    except Exception as e:
        print(f"Error downloading files: {e}")
        return False


index_link = args.index
if not 'workers.dev' in index_link:
    try:
        extract_url = requests.get(url=index_link)
        index_link = extract_url.history[0].headers['location']
    except IndexError:
        index_link = args.index


username = args.user if args.user else "username-default"
password = args.password if args.password else "password-default"

main(url=index_link, username=username, password=password)
time.sleep(1)
remove_duplicates(list_file)
time.sleep(2)
download_files_from_list()