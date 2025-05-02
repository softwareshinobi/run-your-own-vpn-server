# Project Title (e.g., Secure Network Gateway with OpenVPN)

## Description

This project provides a secure network gateway solution built using Docker and Docker Compose. It includes an OpenVPN server for establishing secure connections, auxiliary services for managing VPN client keys and documentation, and a basic authentication proxy. The setup is designed to provide controlled access to internal network resources via the VPN.

## Features

* Containerized OpenVPN server
* Web-based service for distributing OpenVPN client configuration and keys (behind a proxy)
* Web-based documentation server for VPN users
* Basic authentication proxy for controlling access to internal services
* Modular design using Docker Compose

## Prerequisites

Before you begin, ensure you have the following installed:

* **Docker:** Make sure Docker is installed and running on your host machine. Follow the official Docker installation guide for your operating system.
* **Docker Compose:** Install Docker Compose, which is used to define and run multi-container Docker applications. Follow the official Docker Compose installation guide.

## Setup and Installation

1.  **Clone the Repository:**
    ```bash
    git clone <repository_url>
    cd <repository_directory>
    ```
    (Replace `<repository_url>` and `<repository_directory>` with your project's details)

2.  **Prepare Volumes:**
    Ensure the necessary volume directories exist on your host machine. Based on the `docker-compose.yml`, you need a directory at `/volumes/intranet/openvpn`.
    ```bash
    mkdir -p /volumes/intranet/openvpn
    ```
    **Note:** Adjust the volume path (`/volumes/intranet/openvpn`) if your host machine uses a different path.

3.  **Configure OpenVPN (Initial Setup):**
    The `kylemanna/openvpn` image requires initial configuration to generate certificates and keys. Refer to the `kylemanna/openvpn` documentation for detailed steps on how to generate your initial configuration and client certificates/keys. These files should be placed in the `/volumes/intranet/openvpn` directory you created.

4.  **Build Custom Images (if applicable):**
    Some services (`private-openvpn-keys`, `private-openvpn-docs`, `private-network-landing`) are built from a `Dockerfile` within specific contexts (`publisher`, `docs`, `landing`). Ensure these directories and Dockerfiles exist and are correctly configured for your needs. Docker Compose will build these automatically during the `up` process.

5.  **Configure Environment Variables:**
    Review the `public-openvpn-proxy` service in the `docker-compose.yml`. You should set the `BASIC_AUTH_USERNAME` and `BASIC_AUTH_PASSWORD` environment variables to secure the proxy. Consider using a `.env` file for managing these secrets (see Docker Compose documentation on environment files).

    ```yaml
    # Example .env file
    BASIC_AUTH_USERNAME=your_username
    BASIC_AUTH_PASSWORD=your_secure_password
    ```

6.  **Start the Services:**
    Once the volumes are set up and basic configuration is done, start the services using Docker Compose:
    ```bash
    docker-compose up -d
    ```
    The `-d` flag runs the services in detached mode (in the background).

## Configuration

Key configuration points include:

* **OpenVPN Server:** Configuration files and client certificates/keys located in the mounted volume (`/volumes/intranet/openvpn`).
* **OpenVPN Proxy:** Basic authentication credentials set via environment variables (`BASIC_AUTH_USERNAME`, `BASIC_AUTH_PASSWORD`). The `PROXY_PASS` variable determines where the proxy forwards requests (`http://private-openvpn-keys/` in this case).
* **Internal Service Bindings:** Note that services like `private-openvpn-keys` and `private-network-landing` are bound to specific internal IP addresses (`127.0.0.1`, `10.28.1.1`). This means they are not directly accessible from the public internet but are available to other services or clients connected to those specific interfaces (e.g., via the VPN or locally on the host).

## Usage

* **OpenVPN Access:** Connect to the OpenVPN server using your OpenVPN client software and the configuration file generated in the setup steps. The server is accessible on UDP port 1194 on the host's public IP address.
* **Key Distribution/Proxy:** Access the key distribution service via the `public-openvpn-proxy`. Based on the configuration, this service is exposed on **TCP port 1194** of the host. You will likely need to authenticate using the basic authentication credentials configured for the proxy. The proxy then forwards requests to the internal `private-openvpn-keys` service.
* **Documentation:** The documentation service is exposed on **TCP port 1180** of the host. Access this port via your web browser to view the VPN server documentation.
* **Internal Services:** Services bound to internal IPs (like the landing page on ports 5

## Necessary Firewall Configuration

| IP Version | Type          | Protocol | Port Range | Source      | Description                                     | Related Service(s)               |
|------------|---------------|----------|------------|-------------|-------------------------------------------------|----------------------------------|
| IPv4       | SSH           | TCP      | 22         | 0.0.0.0/0   | Allows secure shell access for management       | Host machine                     |
| IPv4       | HTTP          | TCP      | 80         | 0.0.0.0/0   | Allows standard web access                      | (Potentially for web UI or proxy) |
| IPv4       | HTTPS         | TCP      | 443        | 0.0.0.0/0   | Allows secure web access                        | (Potentially for web UI or proxy) |
| IPv4       | Custom TCP    | TCP      | 1194       | 0.0.0.0/0   | Allows TCP traffic on port 1194                 | `public-openvpn-proxy`           |
| IPv4       | Custom UDP    | UDP      | 1194       | 0.0.0.0/0   | Allows OpenVPN traffic (IPv4)                   | `public-openvpn-server`          |

