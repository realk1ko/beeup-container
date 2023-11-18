![Screenshot](screenshot.png)

# Bee-Up Container

[![License](https://img.shields.io/github/license/realk1ko/beeup-container.svg)](https://github.com/realk1ko/beeup-container/blob/master/LICENSE)

> Bee-Up is an ADOxx-based hybrid modelling tool, encompassing five different modelling languages:
> * BPMN - Business Process Model and Notation
> * EPC - Event-driven Process Chains
> * ER - Entity Relationship Diagrams
> * UML - Unified Modeling Language
> * Petri Nets

_&#8213; https://bee-up.omilab.org/activities/bee-up/_

## About

This repository serves as an alternative installation approach for Bee-Up to simplify the already complicated
installation process. Instead of a native application, you use your browser to create some fancy diagrams for your
modelling class in university.

## Usage

### Quick Start

To get started with an automated installation, do the following:

1) [Clone this repository](https://docs.github.com/en/get-started/getting-started-with-git/about-remote-repositories#cloning-with-https-urls)
2) Then, run the installation script:
    - **Linux/MacOS:** Open a terminal inside the repository folder and run `bash install.sh`
    - **Windows:** Open a PowerShell inside the repository folder and run `install.ps1`
3) Follow the instructions printed by the script
4) Afterwards refer to [Notes on Usage](#notes-on-usage) for some tips

If you wish to remove the components installed by the script, do the following:

- **Linux/MacOS:** Open a terminal inside the repository folder and run `bash uninstall.sh`
- **Windows:** Open a PowerShell inside the repository folder and run `uninstall.ps1`

### Manual Setup

The following tags are published to the GitHub Container Registry:

- The `:latest` tag refers to the latest stable container image
- Additionally each published image is tagged with the installed Bee-Up version (e. g. `1.7`). Refer to the packages
  overview [here](https://github.com/users/realk1ko/packages/container/package/beeup) for more info.

The container's HTTP port defaults to `8080`.

Within the running container the following directories might be of interest for a manual setup:

| Directory        | Description                                          |
|------------------|------------------------------------------------------|
| `/home/app/data` | Contains the SQLite database files created by Bee-Up |
| `/home/app/pdf`  | Target directory for the PDF printing function       |

The following run command can be used as an guide for a manual setup:

```
sudo docker run --name beeup \
    --restart unless-stopped \
    -d \
    -p 8080:8080 \
    -v beeup:/home/app/data \
    -v "$(pwd)/pdf":/home/app/pdf \
    ghcr.io/realk1ko/beeup:latest
```

### Notes

- Turn on remote resizing for the best user experience. Click on the gear icon (options) on the left hand side and
  change the scaling mode.
- The installation script sets up a directory within the repository folder (`./pdf`) into which the PDF printed models
  are exported.
- The bundled standard attribute profiles (`*.adl`) should be imported automatically. If for some reason this import
  fails, you can find them in `/home/app/adl` inside the container.
- The installation script sets up a volume for the SQLite database named `beeup`. This volume is removed if the
  uninstall script is run. **Make sure to properly backup in case of version upgrades!**
- Upon first startup of a (persistent) container, the non-automated parts of the installation process will run. This
  includes the PDF printer setup, Wine initialization, Bee-Up license setup and (optionally) the Bee-Up database
  initialization.
