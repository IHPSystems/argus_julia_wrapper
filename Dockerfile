FROM --platform=linux/arm64 ubuntu:18.04

ARG L4T_VERSION=32.6.1
ARG L4T_TARGET=210

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        ca-certificates \
        gnupg \
    && rm -rf /var/lib/apt/lists/*

RUN L4T_VERSION_MAJOR=`echo ${L4T_VERSION} | cut -d . -f 1` \
    && L4T_VERSION_MINOR=`echo ${L4T_VERSION} | cut -d . -f 2` \
    && echo "deb https://repo.download.nvidia.com/jetson/common r${L4T_VERSION_MAJOR}.${L4T_VERSION_MINOR} main" >>  /etc/apt/sources.list.d/nvidia.list \
    && echo "deb https://repo.download.nvidia.com/jetson/t${L4T_TARGET} r${L4T_VERSION_MAJOR}.${L4T_VERSION_MINOR} main" >>  /etc/apt/sources.list.d/nvidia.list \
    && apt-key adv --fetch-key http://repo.download.nvidia.com/jetson/jetson-ota-public.asc \
    && apt-get update \
    && mkdir -p /opt/nvidia/l4t-packages \
    && touch /opt/nvidia/l4t-packages/.nv-l4t-disable-boot-fw-update-in-preinstall \
    && DEBIAN_FRONTEND=noninteractive yes | apt-get install --no-install-recommends \
        nvidia-l4t-jetson-multimedia-api \
    && rm -rf /var/lib/apt/lists/*
