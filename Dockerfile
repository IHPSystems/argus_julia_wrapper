FROM --platform=linux/arm64 ubuntu:18.04

ARG JULIA_VERSION=1.6.5
ARG L4T_VERSION=32.6.1
ARG L4T_TARGET=210

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        cmake \
        gnupg \
        pkg-config \
        wget \
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

RUN JULIA_VERSION_MAJOR=`echo ${JULIA_VERSION} | cut -d . -f 1` \
    && JULIA_VERSION_MINOR=`echo ${JULIA_VERSION} | cut -d . -f 2` \
    && cd /opt \
    && wget https://julialang-s3.julialang.org/bin/linux/aarch64/${JULIA_VERSION_MAJOR}.${JULIA_VERSION_MINOR}/julia-${JULIA_VERSION}-linux-aarch64.tar.gz \
    && tar xfz julia-${JULIA_VERSION}-linux-aarch64.tar.gz \
    && rm julia-${JULIA_VERSION}-linux-aarch64.tar.gz \
    && ln -s julia-${JULIA_VERSION} julia
ENV PATH=${PATH}:/opt/julia/bin
