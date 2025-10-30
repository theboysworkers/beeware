<p align="center">
  <a href="https://theboysworkers.github.io/beeware">
    <img src="https://theboysworkers.github.io/beeware/logo.svg" alt="Logo" width="300" height="300">
  </a>
  <br><br>
  <strong>Capture and analyze malicious traffic effectively...</strong>
</p>
<br>

_This project originated as a bachelor's thesis at Roma Tre University, aimed at creating a honeypot to emulate a corporate network. It was developed by two students, Michela Sciuranza and Lorenzo Ricciardi._

![Network Architecture](https://theboysworkers.github.io/beeware/network.drawio.png)

>  #### [Wiki](https://github.com/theboysworkers/beeware/wiki)
>  The wiki provides detailed documentation, deployment instructions, tutorials, and additional resources for using and extending Beeware.


### Installation
- Clone the repository 
- Run `./pull-images.sh` to download and install the necessary Docker images.
- Run `./launcher.sh` to start the lab environment. This script creates all the containers; depending on your system, the complete deployment may take up to one minute. Monitor the script output for progress and any potential errors.


> **Note:**  
> To run and simulate the entire honeypot infrastructure described in this document, it is **necessary to have Docker and Kathará installed** on your system.  
> * Docker enables containerization and management of all services in an isolated and scalable environment. You can download Docker here: [https://www.docker.com/get-started](https://www.docker.com/get-started).  
> * Kathará allows full network emulation and lab management. Download here: [https://www.kathara.org](https://www.kathara.org).
