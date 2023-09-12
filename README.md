# BPS for Docker Desktop

bps-for-docker-desktop is a solution that allows automated launch of a local WEBCON BPS instance based on Docker Desktop software.

# Requirements:
- Windows 11 with Docker Desktop installed with the ability to run Windows and Linux containers.
- ~10GB of disk space.
- Powershell (tested using Powershell 7).

# Quick start:
1. Pull repo.
`git clone https://github.com/mmbednarz/bps-docker-desktop.git`

2. Start BPS.
`cd .\bps-docker-desktop\`
`./start.ps1`

    Several linux and windows containers will be launched: SQL Server, SOLR, Caddy, bps-init, bps-portal, bps-service.
    The first run time is approximately 30 minutes (due to the need to download docker images and initialize the BPS databases), subsequent runs are approximately 2 minutes.

    ---
    **IMPORTANT!** 

    During installation, a message may be displayed asking you to accept the installation of certificates. This is necessary to run BPS Studio.
   
    ---

4. Once launched, the portal page will launch in your default browser.
The BPS Admin password is: `P@ssw0rd`

# Port reservations
All services are available directly on the host, ports used:
- `8433` TCP for SQL Server
- `8983` TCP for SOLR
- `8080` TCP for BPS Portal
- `80` TCP and `443` TCP for Caddy reverse proxy
- `8002` TCP and `8003` TCP for BPS Service

# Volumes
All volumes are mounted in the data directory.

# User accounts
- sql login `sa`, password `P@ssw0rd`
- srol admin `solr`, password `123qweasdZXC`
- BPS Admin password `P@ssw0rd`
