#!/usr/bin/env bash

set -ex

cut -d: -f1 /etc/passwd
ls /opt/HuarayTech/MVviewer/include/ -la
ls /opt/HuarayTech/MVviewer/lib/ -la
ls /opt/HuarayTech/MVviewer/bin/ -la

sudo chmod -R g-r /opt/HuarayTech/MVviewer/include/*
whoami
groups runner

directory_path_of_this_script=$(dirname $(readlink -f "$0"))
rm $directory_path_of_this_script/build -rf
mkdir $directory_path_of_this_script/build
cd $directory_path_of_this_script/build
cmake -DCMAKE_BUILD_TYPE=Debug ..
make
$directory_path_of_this_script/build/main
