#!/usr/bin/env bash

set -ex

installer_file_name=MVviewer_Ver2.4.2.9_Linux_x86_Build20240923.run
wget -P /tmp https://github.com/sakurai-ryuhei/reproduce-interference-between-librealsense2-and-mvviewer/releases/download/v0.0.0/$installer_file_name
chmod +x /tmp/$installer_file_name
yes yes | sudo /tmp/$installer_file_name --nox11

cut -d: -f1 /etc/passwd
whoami
ls /opt/HuarayTech/MVviewer/include/ -la
ls /opt/HuarayTech/MVviewer/lib/ -la
ls /opt/HuarayTech/MVviewer/bin/ -la
