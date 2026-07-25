# IEEE 802.11 Wi-Fi Networking

## Overview

This section presents the deployment and analysis of an IEEE 802.11 Wireless Local Area Network (WLAN) using Linux-based systems and Raspberry Pi devices. The laboratory environment focuses on low-level wireless configuration, manual Access Point deployment, client authentication, spectrum analysis and packet inspection.

Rather than relying on graphical network managers, the infrastructure is configured entirely through native Linux networking tools, providing a deeper understanding of wireless communication mechanisms, security protocols and RF spectrum behavior.

---

## Objectives

The main objectives of this module are:

- Deploy a functional IEEE 802.11 WLAN using Linux and Raspberry Pi devices.
- Configure wireless interfaces manually using Linux networking tools.
- Implement Open, WEP and WPA/WPA2 wireless security configurations.
- Evaluate channel allocation and spectrum utilization in both the 2.4 GHz and 5 GHz bands.
- Capture and analyze IEEE 802.11 traffic using professional monitoring tools.
- Validate wireless communication through packet inspection and connectivity testing.

---

## Laboratory Architecture

The laboratory consists of a software-defined wireless network with separate management and data planes.

- **Access Point (AP):** Ubuntu Linux workstation configured using Hostapd.
- **Mobile Station (MS):** Raspberry Pi acting as the wireless client.
- **Management Network:** Independent SSH connection used for remote administration.
- **Data Network:** Dedicated wireless interface used for IEEE 802.11 communication.

This architecture allows wireless interfaces to be reconfigured without losing remote administrative access.

---

## Hardware and Software Environment

### Hardware

- TP-LINK TL-WDN4800 (Atheros chipset)
- TP-LINK TL-WN725N USB adapter
- Tenda W522U USB adapter
- Raspberry Pi
- Ubuntu Linux workstation

### Software

- Ubuntu Linux
- Hostapd
- wpa_supplicant
- iw / iwconfig / iwlist
- Wireshark
- Kismet
- inSSIDer

---

## Wireless Network Configuration

The Access Point is deployed using **Hostapd**, while client authentication is managed with **wpa_supplicant**.

The wireless deployment includes:

- Manual interface configuration
- Static IPv4 addressing
- Hostapd-based Access Point deployment
- WPA client authentication
- Wireless interface management through Linux CLI

Channel selection is performed after analyzing spectrum occupancy. The **5 GHz band** is selected because it provides non-overlapping channels and significantly lower interference compared with the congested 2.4 GHz ISM band.

Configuration files used throughout the deployment are available in the **config/** directory.

---

## Wireless Security

Three different IEEE 802.11 security configurations are implemented and evaluated:

- **Open Network**
- **WEP Authentication**
- **WPA/WPA2 Authentication**

These scenarios allow comparison between legacy and modern wireless security mechanisms while validating authentication procedures using Linux networking tools.

---

## Traffic Capture and Analysis

Wireless traffic is monitored using several analysis tools.

The project includes:

- Spectrum analysis with **inSSIDer**
- Passive wireless monitoring using **Kismet**
- IEEE 802.11 frame inspection with **Wireshark**
- Beacon frame analysis
- Association and authentication validation
- Signal strength evaluation

Packet captures are stored in the **pcaps/** directory for later inspection.

---

## Validation

Wireless connectivity is verified after each deployment stage by validating:

- Access Point availability
- Client association
- Successful authentication
- IP connectivity
- IEEE 802.11 management frames
- Beacon frame generation
- Packet captures obtained through monitor mode

The captured traces confirm the correct operation of the wireless infrastructure and validate the implemented configurations.

---

## Design Decisions

Several engineering decisions were adopted during the laboratory deployment:

- Selection of the 5 GHz spectrum to reduce interference.
- Separation of management and data planes for safer administration.
- Exclusive use of Linux command-line networking tools.
- Manual configuration instead of graphical network managers.
- Packet-level validation using Wireshark and Kismet.

---

## Summary

This module demonstrates the deployment, configuration and validation of an IEEE 802.11 wireless infrastructure using Linux networking tools. The project covers Access Point configuration, client authentication, wireless security, spectrum analysis and packet inspection, providing practical experience with WLAN deployment and wireless network troubleshooting.
