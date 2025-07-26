#!/bin/bash

# Exit on any error
set -e

echo "==> Cleaning old Microsoft sources (if any)..."
sudo rm -f /etc/apt/sources.list.d/microsoft-prod.list

echo "==> Update apt"
sudo apt-get update

echo "==> Adding Microsoft Packages for Bookworm 12"
curl https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb > ./packages-microsoft-prod.deb
sudo apt install ./packages-microsoft-prod.deb

echo "Install the container engine"
sudo apt-get install moby-engine

echo "Install the iot edge runtime"
sudo apt-get install aziot-edge
echo "==> IoT Edge Installed Successfully."

read -p "Enter your Azure IoT Device Connection String: " DEVICE_CONN_STR

echo "==> Configuring IoT Edge with device connection string..."
sudo iotedge config mp --connection-string "$DEVICE_CONN_STR"

echo "==> Restarting IoT Edge Service..."
sudo systemctl restart aziot-edged

echo "==> Verifying IoT Edge status..."
sudo iotedge check

echo "==> Done! Your Raspberry Pi is now configured as an Azure IoT Edge device."
echo "Use 'sudo iotedge list' to see running modules."

