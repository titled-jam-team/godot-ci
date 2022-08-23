#!/usr/bin/env bash
cd /workspace || exit 1

apt update
apt install -y build-essential scons pkg-config libx11-dev libxcursor-dev libxinerama-dev libgl1-mesa-dev libglu-dev \
    libasound2-dev libpulse-dev libudev-dev libxi-dev libxrandr-dev yasm clang binutils git

mkdir emsdk
cd emsdk
git init
git remote add origin https://github.com/emscripten-core/emsdk.git
git fetch origin tag 3.1.19 --no-tags
git checkout tags/3.1.19

./emsdk install 3.1.19
./emsdk activate 3.1.19
source ./emsdk_env.sh

cd ..
mkdir godot
mv custom.py godot/custom.py
cd godot
git init
git remote add origin https://github.com/godotengine/godot.git
git fetch origin tag 3.5-stable --no-tags
git checkout tags/3.5-stable

scons platform=server use_llvm=yes use_lld=yes use_thinlto=yes target=release_debug tools=yes optimize=size debug_symbols=no use_static_cpp=yes bits=64
scons platform=javascript tools=no target=release javascript_eval=no
strip bin/godot_server.x11.opt.tools.64.llvm

cp /usr/lib/x86_64-linux-gnu/libatomic.so.1.2.0 /workspace/libatomic.so.1