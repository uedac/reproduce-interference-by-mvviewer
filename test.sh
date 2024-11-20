#!/usr/bin/env bash

set -ex

sudo chmod -R -r /opt/HuarayTech/MVviewer/include/*
directory_path_of_this_script=$(dirname $(readlink -f "$0"))
rm $directory_path_of_this_script/build -rf
mkdir $directory_path_of_this_script/build
cd $directory_path_of_this_script/build
cmake -DCMAKE_BUILD_TYPE=Debug ..
make
$directory_path_of_this_script/build/main
