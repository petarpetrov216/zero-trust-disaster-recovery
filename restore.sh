#!/bin/bash
set -e

echo "Stopping stack..."
docker compose down

echo "Restoring controller DB..."
cp -r ./ziti/controller/db /opt/zero-trust-disaster-recovery/ziti/controller/

echo "Restoring router configs..."
cp -r ./ziti/router /opt/zero-trust-disaster-recovery/ziti/

echo "Restoring Caddy TLS..."
cp -r ./caddy/acme /opt/zero-trust-disaster-recovery/caddy/

echo "Starting stack..."
docker compose up -d

echo "Restore complete."

