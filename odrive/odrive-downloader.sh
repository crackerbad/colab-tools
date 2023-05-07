#!/bin/bash
python3 /content/tools/odrive/odrive.py -u "$1" -i
rm download_*.txt
rm cookies_*.txt