# CHANGELOG

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/) and [Keep a Changelog](http://keepachangelog.com/).


## Unreleased
---

### New

### Changes

### Fixes

### Breaks


## 0.1.2 (2022-03-16)
---

### Changes
FA-58: "restart: unless-stopped" to the VPS docker compose configuration, to let the containers stay active on server reboots.
FA-31: Separate databases for prod, staging and development.
Increase the VPS DKR images version.

### New
Add Python scripts to get IP and scan the network.
Create this repo `version.tx`t, `README.md` and `CHANGELOG.md` files.


## 0.1.11 (2022-03-10)
---

### New
Preview version with initial deployment of BE (Backend) and FE (Frontend) of Fynapp webapp.
Release notes:
FA-3: Create a pipeline to build and deploy the backend to a docker container in a Linux VPS.
FA-13: Create a develop branch and start using it with good SDLC practices.
FA-18: Create a pipeline to build and deploy BE & FE on Heroku.
FA-21: Recover local I5 y/o Celeron server and install Centos 7.
FA-22: Install and configure Kubernetes on the local server and perform a spike the evaluate using this technology.
FA-23: Build a docker image in a Gitlab pipeline by install a Gitlab runner.
