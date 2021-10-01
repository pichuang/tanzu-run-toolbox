#!/bin/bash

wget --no-check-certificate https://172.18.30.1/certs/download.zip
unzip -o download.zip -d /tmp
cp /tmp/certs/lin/* /etc/ssl/certs
rm download.zip
