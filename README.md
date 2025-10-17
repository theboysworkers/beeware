<p align="center">
  <a href="https://theboysworkers.github.io/beeware">
    <img src="https://theboysworkers.github.io/beeware/logo.svg" alt="Logo" width="300" height="300">
  </a>
  <br><br>
  <strong>Capture and analyze malicious traffic effectively...</strong>
</p>

# Beeware — Honeypot Deployment Documentation

**Repository / Wiki:** https://github.com/theboysworkers/beeware/wiki  
> **It is strongly recommended to read the wiki** for detailed instructions, examples, and deployment guidance.

---

## Description

Beeware is a collection of scripts and resources for deploying honeypots and analyzing malicious network traffic in a controlled lab environment. It is designed for educational and research purposes, allowing easy setup of vulnerable network scenarios, data collection, and subsequent analysis.

**Note:** This project was developed as part of a **bachelor's thesis at Roma Tre University** by **Michela Sicuranza** and **Lorenzo Ricciardi**, using the **Kathará framework** for network emulation and honeypot deployment.

---

## Key Features

- Templates and scripts to deploy various types of honeypots.
- Integration with traffic capture and analysis tools.
- Network configurations reproducible using Kathara.
- Step-by-step documentation for conducting controlled experiments.
- Logging mechanisms for forensic or research analysis.

---

## Requirements

- Linux system is **recommended** (Fedora/Ubuntu/Debian/...).  
  > Most scripts, bash/sh commands, and Kathara are fully supported on Linux.  

- Windows **can be used**, but some scripts may require adjustments and bash/sh commands will **not work natively**.  
  > Using WSL (Windows Subsystem for Linux) or a Linux VM is recommended for full functionality.

- Python 3.x
- Kathará (https://www.kathara.org/) — used to emulate network topologies.
- Docker for run containers 