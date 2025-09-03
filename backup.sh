#!/bin/bash

cp /home/hugo/Pictures/img.jpeg /var/backups/img_$(date +"%Y-%m-%d_%H-%M-%S").jpeg

echo "Backup de img.jpeg realizado em $(date +"%Y-%m-%d às %H:%M:%S")" >> /var/log/log.txt
tail -n 1 /var/log/log.txt

