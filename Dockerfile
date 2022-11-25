ARG DEBIAN_VERSION=3-bookworm
FROM torizon/debian:${DEBIAN_VERSION}

RUN apt-get update && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get -y install --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        gpg \
        curl

RUN curl https://deepviewml.com/apt/key.pub | gpg --dearmor -o /usr/share/keyrings/deepviewml.gpg
RUN echo 'deb [signed-by=/usr/share/keyrings/deepviewml.gpg] https://deepviewml.com/apt stable main' > /etc/apt/sources.list.d/deepviewml.list

RUN apt-get update && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get -y install --no-install-recommends \
        libg2d-viv \
        imx-gpu-viv-tools \
        imx-gpu-viv-wayland \
        imx-gpu-viv-wayland-dev \
        python3-cffi \
        python3-numpy \
        libgomp1 \
        libdeepview-rt \
        libdeepview-rt-openvx \
        deepview-rt-modelrunner \
        deepview-rt-python \
        libvaal \
        vaal-python \
        && rm -rf /var/lib/apt/lists/*
