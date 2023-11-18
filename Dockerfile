ARG BASE_IMAGE

FROM ${BASE_IMAGE}

LABEL org.opencontainers.image.title Bee-Up
LABEL org.opencontainers.image.description Bee-Up is an ADOxx-based hybrid modelling tool
LABEL org.opencontainers.image.licenses MIT
LABEL org.opencontainers.image.url https://github.com/realk1ko/beeup-container
LABEL maintainer realk1ko <32820057+realk1ko@users.noreply.github.com>

# Basics
ENV HOME=/home/app \
    PUID=1000 \
    PGID=1000

RUN set -eu && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        bash \
        supervisor

RUN set -eu && \
    groupadd --gid "${PGID}" app && \
    useradd --create-home --home-dir "${HOME}" --shell /bin/bash --uid "${PUID}" --gid "${PGID}" app

WORKDIR ${HOME}

CMD [ "supervisord", "-c", "/etc/supervisord.conf" ]

# VNC
ENV HTTP_PORT=8080 \
    APP_NAME=Bee-Up \
    DISPLAY=:0 \
    VNC_PASSWORD=beeup

RUN set -eu && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        tigervnc-standalone-server \
        novnc \
        openbox

EXPOSE ${HTTP_PORT}

# Build dependencies
ENV LC_ALL=en_US

RUN set -eu && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        wget \
        gnupg \
        lsb-release \
        locales && \
    locale-gen en_US

# CUPS
RUN set -eu && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        cups \
        printer-driver-cups-pdf

# Wine
ARG WINE_VERSION

ENV WINEARCH=win64 \
    WINEPREFIX="${HOME}/.wine" \
    WINEDEBUG=-all

RUN set -eu && \
    wget -nv -O- https://dl.winehq.org/wine-builds/winehq.key | APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 apt-key add - && \
    echo "deb https://dl.winehq.org/wine-builds/ubuntu/ $(grep VERSION_CODENAME= /etc/os-release | cut -d= -f2) main" >> /etc/apt/sources.list && \
    dpkg --add-architecture i386 && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        winehq-stable="${WINE_VERSION}~$(grep VERSION_CODENAME= /etc/os-release | cut -d= -f2)-1" \
        wine-stable="${WINE_VERSION}~$(grep VERSION_CODENAME= /etc/os-release | cut -d= -f2)-1" \
        wine-stable-amd64="${WINE_VERSION}~$(grep VERSION_CODENAME= /etc/os-release | cut -d= -f2)-1" \
        wine-stable-i386="${WINE_VERSION}~$(grep VERSION_CODENAME= /etc/os-release | cut -d= -f2)-1"

# Bee-Up
ADD ./container /

ENV INSTALL_PATH="${WINEPREFIX}/drive_c/Program Files/Bee-Up" \
    ADO_SQLITE_DBFOLDER="${HOME}/data" \
    ADO_LICENSE_KEY="zAd-nvkz-YnrvwreuEKAL2pI"

RUN set -eu && \
    mkdir -p "${INSTALL_PATH}" && \
    mkdir -p "${ADO_SQLITE_DBFOLDER}" && \
    mkdir -p "${HOME}/pdf" && \
    mkdir -p "${HOME}/adl" && \
    cp -rf "${HOME}/installer/install-support/app/"* "${INSTALL_PATH}" && \
    cp -rf "${HOME}/installer/"*.adl "${HOME}/adl" && \
    rm -rf "${HOME}/installer" && \
    chmod +x "${HOME}/.local/bin/"*.sh && \
    chown -R "${PUID}"."${PGID}" "${HOME}"

# Clean up apt cache
RUN set -eu && \
    rm -rf /var/lib/apt/lists/*
