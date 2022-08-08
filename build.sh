#!/usr/bin/env bash
cd /workspace || exit 1

apt update
apt install -y build-essential scons pkg-config libx11-dev libxcursor-dev libxinerama-dev libgl1-mesa-dev libglu-dev \
    libasound2-dev libpulse-dev libudev-dev libxi-dev libxrandr-dev yasm clang binutils git

git init
git remote add origin https://github.com/godotengine/godot.git
git fetch origin tag 3.5-stable --no-tags
git checkout tags/3.5-stable

scons platform=server use_llvm=yes use_lld=yes use_thinlto=yes target=release_debug tools=yes optimize=size debug_symbols=no bits=64
strip bin/godot_server.x11.opt.tools.64.llvm