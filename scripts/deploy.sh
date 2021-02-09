#!/bin/bash
set -e

./scripts/destroy.sh
./scripts/build-static-site.sh

source ./config/versioned

docker network ls | grep "$DOCKERNETWORK" || docker network create "$DOCKERNETWORK"

docker run --rm -d \
  --name "$DOCKERNAME" \
  --network "$DOCKERNETWORK" \
  -p "$DOCKERPORT":80 -v "$PWD/docs/_site":/usr/local/apache2/htdocs/ httpd:2.4

echo ""
echo "Visit http://0.0.0.0:$DOCKERPORT to see the site locally."
echo ""
echo "Use ./scripts/destroy.sh to completely stop the local Docker development environment."
echo ""
