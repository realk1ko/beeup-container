ARG BASE_IMAGE

FROM ${BASE_IMAGE}

LABEL org.opencontainers.image.title Bee-Up
LABEL org.opencontainers.image.description Bee-Up is an ADOxx-based hybrid modelling tool
LABEL org.opencontainers.image.licenses MIT
LABEL org.opencontainers.image.url https://github.com/realk1ko/beeup-docker
LABEL maintainer realk1ko <32820057+realk1ko@users.noreply.github.com>

ADD ./container /

# Basics
ENV HOME=/home/app \
    PUID=1000 \
    PGID=1000

RUN set -xe && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        bash \
        supervisor

RUN set -xe && \
    groupadd --gid "${PGID}" app && \
    useradd --create-home --home-dir "${HOME}" --shell /bin/bash --uid "${PUID}" --gid "${PGID}" app

WORKDIR ${HOME}

CMD [ "supervisord", "-c", "/etc/supervisord.conf" ]

# VNC
ENV HTTP_PORT=8080 \
    APP_NAME=Bee-Up \
    DISPLAY=:0 \
    VNC_PASSWORD=beeup

RUN set -xe && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        tigervnc-standalone-server \
        novnc \
        openbox

EXPOSE ${HTTP_PORT}

# Build dependencies
ENV LC_ALL=en_US

RUN set -xe && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        wget \
        gnupg \
        lsb-release \
        locales && \
    locale-gen en_US

# CUPS
RUN set -xe && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        cups \
        printer-driver-cups-pdf

# Wine
ARG WINE_VERSION

ENV WINEARCH=win64 \
    WINEPREFIX="${HOME}/.wine_adoxx" \
    WINEDEBUG=-all

RUN set -xe && \
    wget -nv -O- https://dl.winehq.org/wine-builds/winehq.key | APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 apt-key add - && \
    echo "deb https://dl.winehq.org/wine-builds/ubuntu/ $(grep VERSION_CODENAME= /etc/os-release | cut -d= -f2) main" >> /etc/apt/sources.list && \
    dpkg --add-architecture i386 && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        winehq-stable="${WINE_VERSION}~$(grep VERSION_CODENAME= /etc/os-release | cut -d= -f2)-1" \
        wine-stable="${WINE_VERSION}~$(grep VERSION_CODENAME= /etc/os-release | cut -d= -f2)-1" \
        wine-stable-amd64="${WINE_VERSION}~$(grep VERSION_CODENAME= /etc/os-release | cut -d= -f2)-1" \
        wine-stable-i386="${WINE_VERSION}~$(grep VERSION_CODENAME= /etc/os-release | cut -d= -f2)-1"

# MSSQL
RUN set -xe && \
    wget -nv -O- https://packages.microsoft.com/keys/microsoft.asc | APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 apt-key add - && \
    echo "deb https://packages.microsoft.com/ubuntu/$(lsb_release -sr)/mssql-server-2019 $(grep VERSION_CODENAME= /etc/os-release | cut -d= -f2) main" >> /etc/apt/sources.list && \
    echo "deb https://packages.microsoft.com/ubuntu/$(lsb_release -sr)/prod $(grep VERSION_CODENAME= /etc/os-release | cut -d= -f2) main" >> /etc/apt/sources.list && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive ACCEPT_EULA=y apt-get install -y \
        mssql-server \
        mssql-tools \
        unixodbc \
        libodbc1 \
        msodbcsql18

# Post installation tasks
RUN set -xe && \
    # remove apt cache
    rm -rf /var/lib/apt/lists/* && \

    # create required directories
    mkdir -p "${HOME}/PDF" && \
    mkdir -p "${WINEPREFIX}/drive_c/Program Files/BOC/" && \

    # "install" Bee-Up
    cp -rf "${HOME}/bee-up-master-TOOL/TOOL/setup64/BOC/BEEUP16_ADOxx_SA" "${WINEPREFIX}/drive_c/Program Files/BOC/" && \
    cp -rf "${HOME}/bee-up-master-TOOL/TOOL/support64/"*.sql "${HOME}/" && \
    cp -rf "${HOME}/bee-up-master-TOOL/TOOL/"*.adl "${HOME}/" && \
    rm -rf "${HOME}/bee-up-master-TOOL/TOOL/" && \

    # correct permissions
    chmod +x "${HOME}"/*.sh && \
    chown -R "${PUID}"."${PGID}" "${HOME}"
