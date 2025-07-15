![Screenshot](screenshot.png)

# Bee-Up Container

[![License](https://img.shields.io/github/license/realk1ko/beeup-container.svg)](https://github.com/realk1ko/beeup-container/blob/master/LICENSE)

Run Bee-Up in your browser via a pre-built container and spend more time creating diagrams for your modelling class at
university, instead of installing and uninstalling software.

## Quick Start

To do a quick installation, do the following:

1. [Clone this repository](https://docs.github.com/en/get-started/getting-started-with-git/about-remote-repositories#cloning-with-https-urls)

2. Run the installation script:
    - **Linux / macOS** – in the repository folder: `bash install.sh`
    - **Windows** – in the repository folder: `install.ps1` (in a PowerShell terminal)

3. Follow the on-screen instructions.

4. Read [Additional Notes](#additional-notes) for tips.

To uninstall everything again:

- **Linux / macOS** – `bash uninstall.sh`
- **Windows** – `uninstall.ps1` (in a PowerShell terminal)

Refer
to [the PowerShell documentation](https://learn.microsoft.com/en-us/previous-versions//bb613481(v=vs.85)?redirectedfrom=MSDN#how-to-allow-scripts-to-run)
on how to run unsigned PowerShell scripts in Windows.

## Manual Setup

Images published to the GitHub Container Registry use the following tags:

- `:latest` – most recent stable image
- `:<version>` – image with the corresponding Bee-Up version (e.g. `1.7`).

See the full list of available images [here](https://github.com/users/realk1ko/packages/container/package/beeup).

The container's HTTP port defaults to `8080`.

The following directories inside the container may be useful for a manual setup:

| Directory          | Description                                          |
|--------------------|------------------------------------------------------|
| `/home/beeup/data` | Contains the SQLite database files created by Bee-Up |
| `/home/beeup/pdf`  | Target directory for the PDF printing function       |

The following example run command can be used as guidance:

```
sudo docker run --name beeup \
    --restart unless-stopped \
    -d \
    -p 8080:8080 \
    -v beeup:/home/beeup/data \
    -v "$(pwd)/pdf":/home/beeup/pdf \
    ghcr.io/realk1ko/beeup:latest
```

## Additional Notes

- Enable remote resizing for the best experience: Click the gear icon (Options) on the left hand side and adjust the
  scaling mode.
- The installation script creates a directory named `./pdf` in the repository folder. Bee-Up exports printed PDFs there.
- Standard attribute profiles (`*.adl`) are imported automatically. If not, they are available at `/home/beeup/adl`
  inside the container.
- The installation script creates a Docker volume named `beeup` for the SQLite database. The uninstall script removes
  this volume. **Make sure to properly backup in case of version upgrades!**
- On the first start of a persistent container, Bee-Up completes remaining setup steps (PDF printer, Wine
  initialisation, license configuration, and optional database initialization).
