#!/bin/bash

read -p "diretorio: " dir
find "$dir" -type f \( -name "*.elf" -o  -name "*.hex" -o  -name "*.map" -o  -name "*.o" -o  -name "*.sym" \) -print -delete
echo "done"