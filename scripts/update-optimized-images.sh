#!/bin/bash
#
# Publish optimized images.
#
# See https://github.com/dcycle/thumbor-example.
#
set -e

rm -rf ./unversioned/optimized-images
mkdir -p ./unversioned/optimized-images
cd ./unversioned/optimized-images
git clone https://github.com/dcycle/thumbor-example.git
cp -r ../../docs/media ./thumbor-example/my-media
cd thumbor-example
pip3 install python-dotenv libthumbor
python3 ./scripts/generate-image-map.py
