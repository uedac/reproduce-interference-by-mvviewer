#!/usr/bin/env bash

set -ex

sudo apt update
sudo apt install -y \
    build-essential \
    lld \
    cmake \
    git \
    wget \
    curl \
    software-properties-common \
    libopencv-dev \
    libdw-dev

directory_path_of_this_script=$(dirname $(readlink -f "$0"))
$directory_path_of_this_script/mvviewer_installer/install_mvviewer.sh
