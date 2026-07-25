# Wireless Network Engineering

A complete wireless network infrastructure project involving the deployment, analysis, and simulation of modern communication systems using **IEEE 802.11, LoRaWAN, and GSM** technologies.

The project explores local area networks, low-power wide-area telemetry, and large-scale cellular deployments, bridging the gap between theoretical radio frequency (RF) models and empirical network performance.

---

## Project Overview

This project was developed as part of a Telecommunications Engineering degree with the objective of deploying, analyzing, and optimizing wireless networks across different frequency bands and architectures.

The infrastructure includes:

- IEEE 802.11 Wi-Fi networks (2.4 GHz and 5 GHz)
- LoRaWAN IoT telemetry deployment
- Centralized ChirpStack Network/Application server
- Containerized monitoring backend (InfluxDB & Grafana)
- GSM cellular topologies
- Dynamic frequency allocation algorithms
- Mathematical RF simulation environments

---

## Features

- Software-defined AP deployment
- 802.11 Security Auditing (WEP, WPA/WPA2)
- Deep Packet Inspection of MAC-layer frames
- Spectral saturation analysis
- LoRaWAN End-Node OTAA Provisioning
- Containerized backend orchestration
- Real-time RSSI and SNR telemetry tracking
- Mathematical simulation of Carrier-to-Interference Ratio (CIR)
- Frequency Reuse factor analysis
- Game Theory autonomous channel allocation

---

## Technologies

| Category | Technologies |
|-----------|--------------|
| Wireless | IEEE 802.11, LoRaWAN, GSM |
| Programming | MATLAB |
| Networking | Hostapd, WPA Supplicant |
| Analysis | Wireshark, libpcap |
| Monitoring | Grafana |
| Database | InfluxDB |
| Containerization | Docker |
| Operating System | Ubuntu Linux, Raspbian |

---

# Network Topology

The following figure shows the architectural separation of the management and data planes in the IEEE 802.11 deployment.

![Wi-Fi Network Architecture](screenshots/wifi/wifi-network-architecture.png)

---

# Project Structure

```text
wireless-network-engineering/
│
├── docs/
│   ├── 01-project-overview.md
│   ├── 02-ieee-80211-network.md
│   ├── 03-lorawan-iot.md
│   └── 04-gsm-frequency-reuse.md
│
├── scripts/
│   ├── matlab/
│   │   ├── channelallocation.m
│   │   ├── PRUEBA.m
│   │   ├── reuse.m
│   │   └── rng.m
│   └── dashboards/
│       └── 1744362274480.json
│
├── config/
│   ├── hostapd.conf
│   └── wpa_supplicant.conf
│
├── pcaps/
│   └── beacon.pcapng
│
├── screenshots/
│   ├── wifi/
│   ├── lorawan/
│   └── gsm/
│
├── README.md
└── LICENSE
```

---

# Documentation

Detailed technical documentation is available inside the **docs** directory.

| Document | Description |
|----------|-------------|
| [01 - Project Overview](docs/01-project-overview.md) | High-level project architecture, scope, and design decisions |
| [02 - IEEE 802.11 Network](docs/02-ieee-80211-network.md) | WLAN setup, MAC-layer auditing, spectral analysis, and security (WPA2) |
| [03 - LoRaWAN IoT](docs/03-lorawan-iot.md) | LPWAN deployment, OTAA provisioning, and containerized telemetry pipelines |
| [04 - GSM Frequency Reuse](docs/04-gsm-frequency-reuse.md) | Cellular simulation, CIR dynamics, and Game Theory frequency allocation |

---

# Project Highlights

## IEEE 802.11 Packet Analysis

Deep packet inspection of 802.11 management, control, and data frames to audit associations and cryptographic handshakes.

![Wi-Fi Analysis](screenshots/wifi/wireshark-80211-beacon-analysis.png)

---

## LoRaWAN Telemetry

Real-time signal degradation monitoring (RSSI and SNR) of a moving LoRa node using an orchestrated ChirpStack, InfluxDB, and Grafana pipeline.

![LoRaWAN Metrics](screenshots/lorawan/grafana-rssi-snr-metrics.png)

---

## GSM Cellular Simulation

Mathematical modeling of RF path loss, frequency reuse distances, and co-channel interference within large-scale geometries.

![GSM Simulation](screenshots/gsm/cir-cdf-radius-comparison.png)

---

# Learning Outcomes

This project allowed me to gain practical experience with:

- Deployment and configuration of raw Linux wireless networking stacks
- Bypassing standard network managers for granular interface control
- Deep packet inspection and protocol analysis (Wireshark, Kismet)
- End-to-end orchestration of containerized IoT telemetry pipelines
- Securely bridging physical RF hardware to cloud databases
- Mathematical modeling of RF path loss and co-channel interference
- Implementation of Game Theory for dynamic, autonomous cellular frequency planning

---

# Repository Contents

This repository includes:

- Technical engineering documentation
- MATLAB simulation scripts
- Exported Grafana dashboards
- Native Linux networking configuration files
- Raw `.pcapng` network traffic captures
- Visual architecture and telemetry screenshots

---

# License

This project is distributed under the MIT License.
