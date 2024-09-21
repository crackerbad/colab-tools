import os
import subprocess
import shlex

def runSh(args, *, output=False, shell=False, cd=None):
    """Executa comandos de shell."""
    if not shell:
        if output:
            proc = subprocess.Popen(
                shlex.split(args), stdout=subprocess.PIPE, stderr=subprocess.STDOUT, cwd=cd
            )
            while True:
                output = proc.stdout.readline()
                if output == b"" and proc.poll() is not None:
                    return
                if output:
                    print(output.decode("utf-8").strip())
        return subprocess.run(shlex.split(args), cwd=cd).returncode
    else:
        if output:
            return (
                subprocess.run(
                    args,
                    shell=True,
                    stdout=subprocess.PIPE,
                    stderr=subprocess.STDOUT,
                    cwd=cd,
                )
                .stdout.decode("utf-8")
                .strip()
            )
        return subprocess.run(args, shell=True, cwd=cd).returncode


def installJDownloader():
    """Instala o JDownloader se não estiver disponível."""
    if checkAvailable("/root/.JDownloader/JDownloader.jar"):
        return
    else:
        runSh("mkdir -p -m 666 /root/.JDownloader/libs")
        runSh("apt-get install openjdk-8-jre-headless -qq -y")
        runSh(
            "wget -q http://installer.jdownloader.org/JDownloader.jar -O /root/.JDownloader/JDownloader.jar"
        )
        runSh("java -jar /root/.JDownloader/JDownloader.jar -norestart -h")
        runSh(
            "wget -q https://shirooo39.github.io/MiXLab/resources/packages/jdownloader/sevenzipjbinding1509.jar -O /root/.JDownloader/libs/sevenzipjbinding1509.jar"
        )
        runSh(
            "wget -q https://shirooo39.github.io/MiXLab/resources/packages/jdownloader/sevenzipjbinding1509Linux.jar -O /root/.JDownloader/libs/sevenzipjbinding1509Linux.jar"
        )


def startJDService(a=1):
    """Inicia o serviço JDownloader."""
    runSh("pkill -9 -e -f java")
    runSh(
        "java -jar /root/.JDownloader/JDownloader.jar -norestart -noerr -r &",
        shell=True,  # nosec
    )


def checkAvailable(path_="", userPath=False):
    """Verifica se o caminho especificado existe."""
    from os import path as _p

    if path_ == "":
        return False
    else:
        return (
            _p.exists(path_)
            if not userPath
            else _p.exists(f"/usr/local/sessionSettings/{path_}")
        )


# Instala o JDownloader e inicia o serviço
installJDownloader()
startJDService()
