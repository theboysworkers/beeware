<p align="center">
 <a href="https://theboysworkers.github.io/beeware">
    <img src="https://theboysworkers.github.io/beeware/logo.svg" alt="Logo" width="300" height="300">
 </a>
  <br><br>
  <strong>Capture and analyze malicious traffic effectively...</strong>
</p>

# Honeypot Deployment Documentation

## Table of Contents
1. [Introduction](#1-introduction)
2. [Network Architecture](#2-network-architecture)
   - [2.1 Routing Tables](#21-routing-tables)
   - [2.2 Network and Subnets](#22-network-and-subnets)
3. [Services Overview](#3-services-overview)
   - [3.1 LAN A](#31-lan-a)
   - [3.2 LAN B](#32-lan-b)
   - [3.3 LAN C](#33-lan-c)
4. [Namespaces](#4-namespaces)
   - [4.1 Internal Namespace](#41-internal-namespace)
   - [4.2 External Namespace](#42-external-namespace)
5. [How to Use It](#5-how-to-use-it)

---

## 1. Introduction

This document outlines the implementation of a honeypot system.

A **honeypot** is a computing resource intentionally designed to **attract and deceive cyber attackers** by simulating system vulnerabilities or exposing seemingly sensitive data. Its main objective is to **monitor and analyze attack techniques**, gathering valuable intelligence to improve overall security strategies.

Honeypots are powerful tools for **studying malicious behavior** and developing more effective defense mechanisms.  

To simulate a realistic corporate environment, a **network architecture** was designed for a fictional company called **"The Boys"** — a young, dynamic IT firm specializing in tailor-made digital solutions for both businesses and individuals.

To ensure **greater scalability** and **zero deployment costs**, the entire infrastructure is **fully simulated** using the advanced emulation tool [Kathará](https://www.kathara.org).

---

## 2. Network Architecture

The honeypot environment is entirely **IPv6-based**, reflecting modern network standards and challenges. The IT infrastructure of *The Boys* features a **robust and scalable architecture**, designed to support both the production and distribution of digital content efficiently.

### 2.1 Routing Tables

Custom routing tables are configured within the routers to manage traffic across the segmented network. These tables define the paths packets should follow to reach specific subnets, ensuring efficient communication between internal services and network zones.

### 2.2 Network and Subnets

The network is divided into multiple **Local Area Networks (LANs)**, each with a specific functional role. Below is an overview of the main LANs and their representation in the topological schema.

IPv6 addressing has been planned using the base prefix: `2a04::/56`, which is then split into two main subnet groups through **subnetting**.

- The **first macro subnet** is dedicated to servers and hosts critical services such as DNS, web servers, and more.  
  This subnet is further divided to allow for future scalability, yielding **16 subnets** in total.  
  Applied subnetting: `2a04:0:0:0::/60` → `2a04:0:0:f::/60`  
  Currently, only three networks have been implemented:
  - **LAN A**
  - **LAN B**
  - **LAN C**

- The **second macro subnet** is reserved for employee workstations.  
  It is partitioned into a large number of subnets (**up to 240 LANs**) to support potential large-scale deployments.  
  Applied subnetting: `2a04:0:0:10::/60` → `2a04:0:0:ff::/60`  
  Currently active networks:
  - **LAN S** - System administrators network
  - **LAN D** - Managers (executives) network
  - **LAN O** - General Users (others) network

![Network Architecture](https://theboysworkers.github.io/beeware/network.drawio.png)

---

## 3. Services Overview

The following services are deployed within the simulated infrastructure to represent typical enterprise systems. They are distributed across three internal networks (LANs):

### 3.1 LAN A
This LAN hosts core infrastructure services that support authentication, name resolution, and centralized logging within the internal environment.
- **bind1**: Internal DNS server for local hostname resolution and service discovery.  
- **rsyslog**: Centralized logging system for auditing and monitoring.  
- **oldap**: Directory service providing centralized authentication and user management.

### 3.2 LAN B
LAN B contains key backend systems responsible for hosting web applications, managing databases, and providing internal communication and storage services.
- **wsa1**: Apache web server hosting internal web content.  
- **mdb**: MariaDB relational database for storing application and system data.  
- **smb**: Samba server offering Windows-compatible file and printer sharing.  
- **mxs**: Mail server with Postfix and Dovecot services.

### 3.3 LAN C
This LAN provides externally accessible services and secure remote connectivity, acting as the main interface between the internal infrastructure and external users or systems.
- **wsa2**: Apache web server serving public-facing websites and web applications.  
- **wsn**: Nginx server acting as a reverse proxy or lightweight web server.  
- **bind2**: External DNS server for Internet resolution.  
- **ovpn**: OpenVPN server providing secure remote access to the internal network.

---

## 4. Namespaces

### 4.1 Internal Namespace
- **BIND1:** Internal DNS for resolving local network hostnames.  

![Internal Namespace](https://theboysworkers.github.io/beeware/bind1.namespace.drawio.png)

### 4.2 External Namespace
- **BIND2:** External DNS serving Internet queries.

![External Namespace](https://theboysworkers.github.io/beeware/bind2.namespace.drawio.png)

---

## 5. How to Use It

1. Run `./pull-images.sh` to download and install the necessary Docker images.
2. Run `./launcher.sh` to start the lab environment. This script creates all the containers; depending on your system, the complete deployment may take up to one minute. Monitor the script output for progress and any potential errors.

> **Note:**  
> To run and simulate the entire honeypot infrastructure described in this document, it is **necessary to have Docker and Kathará installed** on your system.  
> * Docker enables containerization and management of all services in an isolated and scalable environment. You can download Docker here: [https://www.docker.com/get-started](https://www.docker.com/get-started).  
> * Kathará allows full network emulation and lab management. Download here: [https://www.kathara.org](https://www.kathara.org).

## 6 Tips and tricks

- To test individual containers without opening an interactive shell, you can pipe the script `network-test.sh` into the container like this:  `cat network-test.sh | docker exec -i <container-name> bash`

- To run tests for particular LANs, open `python/main.py` and comment out any import statements for modules you do not wish to include in the current run. Leave the backbone import active at all times because it represents the network’s core/dorsal topology.
