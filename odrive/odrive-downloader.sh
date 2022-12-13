#!/bin/bash
python3 /content/odrive/odrive.py -u "$1" -i
rm download_*.txt
rm cookies_*.txt