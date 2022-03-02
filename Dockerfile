FROM ubuntu:focal

# Copy everything into the container
COPY . .

# Some basic environment variables
ENV HOME=/home/app \
    PUID=1000 \
    PGID=1000 \
    LC_ALL=en_US \
    DISPLAY=:0.0 \
    DISPLAY_WIDTH=1920 \
    DISPLAY_HEIGHT=1080

# Installing base packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        bash \
        novnc \
        x11vnc \
        xvfb \
        fluxbox \
        supervisor \
        wget \
        gnupg \
        lsb-release \
        locales && \
    locale-gen en_US

# Installing Wine
RUN wget -nv -O- https://dl.winehq.org/wine-builds/winehq.key | APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 apt-key add - && \
    echo "deb https://dl.winehq.org/wine-builds/ubuntu/ $(grep VERSION_CODENAME= /etc/os-release | cut -d= -f2) main" >> /etc/apt/sources.list && \
    dpkg --add-architecture i386 && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        winehq-stable=6.0.3~focal-1 \
        wine-stable=6.0.3~focal-1 \
        wine-stable-amd64=6.0.3~focal-1 \
        wine-stable-i386=6.0.3~focal-1

# Installing winetricks
RUN wget -nv -O /usr/bin/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks && \
    chmod +x /usr/bin/winetricks

# Installing MSSQL
RUN wget -nv -O- https://packages.microsoft.com/keys/microsoft.asc | APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 apt-key add - && \
    echo "deb https://packages.microsoft.com/ubuntu/$(lsb_release -sr)/mssql-server-2019 $(grep VERSION_CODENAME= /etc/os-release | cut -d= -f2) main" >> /etc/apt/sources.list && \
    echo "deb https://packages.microsoft.com/ubuntu/$(lsb_release -sr)/prod $(grep VERSION_CODENAME= /etc/os-release | cut -d= -f2) main" >> /etc/apt/sources.list && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive ACCEPT_EULA=Y apt-get install -y \
            mssql-server \
            mssql-tools \
            unixodbc \
            libodbc1 \
            msodbcsql18

# Removing apt cache
RUN rm -rf /var/lib/apt/lists/*

# User setup
RUN groupadd --gid ${PGID} app && \
    useradd --create-home --home-dir "${HOME}" --shell /bin/bash --uid ${PUID} --gid ${PGID} app && \
    chown -R ${PUID}.${PGID} "${HOME}"

WORKDIR ${HOME}

VOLUME ${HOME}/data

EXPOSE 8080

CMD [ "supervisord", "-c", "/etc/supervisord.conf" ]

# Installing Bee-Up
ENV WINEARCH=win64 \
    WINEPREFIX="${HOME}/.wine_adoxx" \
    WINEDEBUG=-all \
    TOOLFOLDER=BEEUP16_ADOxx_SA \
    DATABASE=beeup16_64 \
    LICENSE_KEY=zAd-nvkz-Ynrtvrht9IAL2pZ

USER app

RUN mkdir -p "${WINEPREFIX}/drive_c/Program Files/BOC/" && \
    cp -rf "beeup/setup64/BOC/${TOOLFOLDER}" "${WINEPREFIX}/drive_c/Program Files/BOC/" && \
    cp -rf beeup/support64/odbctemplate.ini "${HOME}/" && \
    cp -rf beeup/support64/create*.sql "${HOME}/" && \
    cp -rf beeup/*.adl "${HOME}/" && \
    rm -rf beeup/ && \
    chmod +x "${HOME}/start.sh"

USER root
