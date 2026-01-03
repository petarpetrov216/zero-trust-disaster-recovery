#!/bin/bash
set -e

echo "[1/6] Updating system..."
apt update -y && apt upgrade -y

echo "[2/6] Installing Docker..."
apt install -y ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) stable"
apt update -y
apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

echo "[3/6] Cloning DR repository..."
if [ ! -d "/opt/zero-trust-disaster-recovery" ]; then
  git clone https://github.com/petarpetrov216/zero-trust-disaster-recovery.git /opt/zero-trust-disaster-recovery
fi

cd /opt/zero-trust-disaster-recovery

echo "[4/6] Restoring controller DB..."
if [ ! -d "./ziti/controller/db" ]; then
  echo "ERROR: Missing controller DB. Place DB files in ziti/controller/db/"
  exit 1
fi

echo "[5/6] Starting Zero Trust stack..."
docker compose up -d

echo "[6/6] Checking health..."
sleep 10
docker ps

echo "Bootstrap complete. Zero Trust stack is running."

