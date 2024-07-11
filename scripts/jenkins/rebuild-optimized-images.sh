#!/bin/bash
set -ex

# The token must be set as an environment variable
if [ -v "$DIGITALOCEAN_ACCESS_TOKEN" ]; then
  >&2 echo "Please set the DIGITALOCEAN_ACCESS_TOKEN environment variable"
  exit 1
fi
# The ssh key must be set as an environment variable
if [ -v "$DIGITALOCEAN_SSH_KEY" ]; then
  >&2 echo "Please set the DIGITALOCEAN_SSH_KEY environment variable"
  exit 1
fi
# The THUMBOR_SECURITY_KEY key must be set as an environment variable
if [ -v "$THUMBOR_SECURITY_KEY" ]; then
  >&2 echo "Please set the THUMBOR_SECURITY_KEY environment variable"
  exit 1
fi
# The TDJ_IMAGE_MAP_DEPLOY_PRIVATE_KEY key must be set as an environment variable
if [ -v "$TDJ_IMAGE_MAP_DEPLOY_PRIVATE_KEY" ]; then
  >&2 echo "Please set the TDJ_IMAGE_MAP_DEPLOY_PRIVATE_KEY environment variable"
  exit 1
fi

# Create a droplet
DROPLET_NAME=docker-tdj-images

doctl compute droplet create "$DROPLET_NAME" --size 4gb --image ubuntu-20-04-x64 --ssh-keys "$DIGITALOCEAN_SSH_KEY"

sleep 45

IP=$(doctl compute droplet get "$DROPLET_NAME" --format PublicIPv4 --no-header)
echo "Created Droplet at $IP"

sleep 45

ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no \
  root@"$IP" "mkdir -p docker-tdj-images"
scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no \
  -r * root@"$IP":docker-tdj-images
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no \
  root@"$IP" "cd docker-tdj-images && export THUMBOR_SECURITY_KEY=$THUMBOR_SECURITY_KEY && ./scripts/install-docker-and-rebuild-optimized-images.sh"
scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no \
  root@"$IP":docker-tdj-images/thumbor-example/mapping.json mapping.json
cat mapping.json
