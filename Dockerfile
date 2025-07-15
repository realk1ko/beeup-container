FROM docker.io/library/ubuntu:latest

LABEL org.opencontainers.image.title=Bee-Up \
      org.opencontainers.image.description=Run Bee-Up in your browser via a pre-built container \
      org.opencontainers.image.licenses=MIT \
      org.opencontainers.image.url=https://github.com/realk1ko/beeup-container \
      maintainer=realk1ko <32820057+realk1ko@users.noreply.github.com>

ENV BEEUP_HOME=/home/beeup \
    # VNC
    HTTP_PORT=8080 \
    DISPLAY=:0 \
    LC_ALL=en_US \
    # Wine
    WINEARCH=win64 \
    WINEPREFIX="/home/beeup/.wine" \
    WINEDEBUG=-all \
    # Bee-Up specifics
    BEEUP_INSTALL_PATH="/home/beeup/.wine/drive_c/Program Files/Bee-Up" \
    ADO_SQLITE_DBFOLDER="/home/beeup/data" \
    ADO_LICENSE_KEY="zAd-nvkz-YnrvwreuEKAL2pI"

RUN set -eux; \
    # rename default user \
    usermod -l beeup ubuntu; \
    groupmod -n beeup ubuntu; \
    usermod -d ${BEEUP_HOME} -m beeup; \
    usermod -c "Bee-Up" beeup; \
    # install requirements for building and running the container and for printing PDFs
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        bash supervisor tigervnc-standalone-server novnc openbox \
        wget gnupg lsb-release locales \
        cups cups-pdf; \
    locale-gen en_US; \
    # install Wine
    wget -nv -O- https://dl.winehq.org/wine-builds/winehq.key | APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 apt-key add -; \
    echo "deb https://dl.winehq.org/wine-builds/ubuntu/ $(grep VERSION_CODENAME= /etc/os-release | cut -d= -f2) main" >> /etc/apt/sources.list; \
    dpkg --add-architecture i386; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        winehq-stable wine-stable wine-stable-amd64 wine-stable-i386; \
    # remove temporary files from APT
    rm -rf /var/lib/apt/lists/*

ADD ./container /

RUN set -eux; \
    # install Bee-Up
    mkdir -p "${BEEUP_INSTALL_PATH}"; \
    mkdir -p "${ADO_SQLITE_DBFOLDER}"; \
    mkdir -p "${BEEUP_HOME}/pdf"; \
    mkdir -p "${BEEUP_HOME}/adl"; \
    cp -rf "${BEEUP_HOME}/installer/install-support/app/"* "${BEEUP_INSTALL_PATH}"; \
    cp -rf "${BEEUP_HOME}/installer/"*.adl "${BEEUP_HOME}/adl"; \
    rm -rf "${BEEUP_HOME}/installer"; \
    chmod ug+x "${BEEUP_HOME}/.local/bin/"*.sh; \
    chown -R "1000:1000" "${BEEUP_HOME}"

CMD [ "supervisord", "-c", "/etc/supervisord.conf" ]

EXPOSE ${HTTP_PORT}
