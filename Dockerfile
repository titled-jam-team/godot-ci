FROM ubuntu:focal as stage1
LABEL author="https://github.com/aBARICHELLO/godot-ci/graphs/contributors"

USER root
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    unzip \
    wget \
    zip \
    && rm -rf /var/lib/apt/lists/*

ARG GODOT_VERSION="3.5"
ARG RELEASE_NAME="stable"
ARG SUBDIR=""

RUN wget https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}${SUBDIR}/Godot_v${GODOT_VERSION}-${RELEASE_NAME}_linux_headless.64.zip \
    && wget https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}${SUBDIR}/Godot_v${GODOT_VERSION}-${RELEASE_NAME}_export_templates.tpz \
    && mkdir ~/.cache \
    && mkdir -p ~/.config/godot \
    && mkdir -p ~/.local/share/godot/templates/${GODOT_VERSION}.${RELEASE_NAME} \
    && unzip Godot_v${GODOT_VERSION}-${RELEASE_NAME}_linux_headless.64.zip \
    && mv Godot_v${GODOT_VERSION}-${RELEASE_NAME}_linux_headless.64 /usr/local/bin/godot \
    && unzip Godot_v${GODOT_VERSION}-${RELEASE_NAME}_export_templates.tpz \
    && mv templates/* ~/.local/share/godot/templates/${GODOT_VERSION}.${RELEASE_NAME} \
    && rm -f Godot_v${GODOT_VERSION}-${RELEASE_NAME}_export_templates.tpz Godot_v${GODOT_VERSION}-${RELEASE_NAME}_linux_headless.64.zip

RUN apt purge -y unzip wget zip && apt --purge -y autoremove

RUN godot -e -q
