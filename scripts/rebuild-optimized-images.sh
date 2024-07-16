#!/bin/bash
# Rebuild omtimized image list.
# See https://github.com/dcycle/thumbor-example

set -e

git clone https://github.com/dcycle/thumbor-example.git
mv docs/media thumbor-example/my-media
cd thumbor-example
./scripts/generate-image-map.sh ./app/my-media contenu.terredesjeunes.org/media 800x,x200 ./app/mapping.json
