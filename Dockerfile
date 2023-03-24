ARG DEBIAN=bullseye
ARG PLATFORM=linux/arm64/v8
ARG TORADEX_FEED_BASE_URL="https://feeds.toradex.com/debian"
ARG TORADEX_SNAPSHOT=20220512T021145Z
ARG USE_TORADEX_SNAPSHOT=1

FROM --platform=${PLATFORM} debian:${DEBIAN}
ARG TORADEX_SNAPSHOT
ARG USE_TORADEX_SNAPSHOT
ARG TORADEX_FEED_BASE_URL
ARG DEBIAN_FRONTEND=noninteractive

ENV LC_ALL C.UTF-8

# Required to enable cross-architecture builds on Docker Hub.
COPY qemu-aarch64-static /usr/bin/

# Create 01_nodoc to disable installation of docs inside docker containers.
COPY 01_nodoc /etc/dpkg/dpkg.cfg.d/01_nodoc

# Create 01_buildconfig which will use the Toradex packages as a priority.
RUN echo 'APT::Get::Assume-Yes "true";\n\
    APT::Install-Recommends "0";\n\
    APT::Install-Suggests "0";\n\
    quiet "true";' > /etc/apt/apt.conf.d/01_buildconfig \
    && mkdir -p /usr/share/man/man1

# Enable the Toradex package feed
# (same key is used in https://gitlab.int.toradex.com/rd/torizon-core-containers/debian-cross-toolchains
# if you change the key or feed configuration, please check the other repo!)
ADD ${TORADEX_FEED_BASE_URL}/toradex-debian-repo.gpg /etc/apt/trusted.gpg.d/
RUN chmod 0644 /etc/apt/trusted.gpg.d/toradex-debian-repo.gpg \
    && if [ "${USE_TORADEX_SNAPSHOT}" = 1 ]; then \
           TORADEX_FEED_URL="${TORADEX_FEED_BASE_URL}/snapshots/${TORADEX_SNAPSHOT}"; \
       else \
           TORADEX_FEED_URL="${TORADEX_FEED_BASE_URL}"; \
       fi \
    && echo "deb ${TORADEX_FEED_URL} testing main non-free" >>/etc/apt/sources.list \
    && echo "Package: *\nPin: origin feeds.toradex.com\nPin-Priority: 900" > /etc/apt/preferences.d/toradex-feeds

RUN apt-get update && apt-get upgrade -y && \
    apt-get -y install --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        gpg \
        curl

# Install DeepView AI Middleware Packages and Dependencies to enable i.MX 8M Plus.
RUN curl https://deepviewml.com/apt/key.pub | gpg --dearmor -o /usr/share/keyrings/deepviewml.gpg
RUN echo 'deb [signed-by=/usr/share/keyrings/deepviewml.gpg] https://deepviewml.com/apt stable main' > /etc/apt/sources.list.d/deepviewml.list

RUN apt-get update && \
    apt-get -y install --no-install-recommends \
        libg2d-viv \
        imx-gpu-viv-tools \
        imx-gpu-viv-wayland \
        imx-gpu-viv-wayland-dev \
        libgomp1 \
        libdeepview-rt \
        libdeepview-rt-openvx \
        deepview-rt-modelrunner \
        libvideostream \
        libvaal
