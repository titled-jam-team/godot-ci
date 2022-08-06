FROM ubuntu:focal as stage1

USER root
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && \
    apt install -y build-essential scons pkg-config libx11-dev libxcursor-dev libxinerama-dev \
    libgl1-mesa-dev libglu-dev libasound2-dev libpulse-dev libudev-dev libxi-dev libxrandr-dev yasm clang binutils git

ARG GODOT_VERSION="3.5"
ARG RELEASE_NAME="stable"
ARG SUBDIR=""

WORKDIR /root

RUN mkdir -p /root/src

WORKDIR /root/src
COPY custom.py /root/src/custom.py

RUN git init \
    && git remote add origin https://github.com/godotengine/godot.git \
    && git fetch origin tag 3.5-stable --no-tags \
    && git checkout tags/3.5-stable

RUN scons platform=server use_llvm=yes use_lld=yes use_thinlto=yes target=release_debug tools=yes optimize=size debug_symbols=no bits=64
RUN strip bin/godot_server.x11.opt.tools.64.llvm

FROM scratch

COPY --from=stage1 /lib/x86_64-linux-gnu/libatomic.so.1 \
                    /lib/x86_64-linux-gnu/libpthread.so.0 \
                    /lib/x86_64-linux-gnu/libdl.so.2 \
                    /lib/x86_64-linux-gnu/libm.so.6 \
                    /lib/x86_64-linux-gnu/libc.so.6 \
                    /lib/x86_64-linux-gnu/

COPY --from=stage1 /lib64/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2

COPY --from=stage1 /root/src/bin/godot_server.x11.opt.tools.64.llvm /bin/godot

ENTRYPOINT [ "/bin/godot" ]