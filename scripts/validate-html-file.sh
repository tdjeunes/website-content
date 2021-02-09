#!/bin/bash
#
# Validate single HTML file.
#
set -e

if [ -z "$1" ]; then
  >&2 echo "Please provide a file name such as ./docs/index.html"
  exit 1
fi

echo ""
echo "*** Checking file $1 ***"
echo ""
docker run --rm -v "$(pwd)":/code dcycle/html-validate:1 --drop-empty-elements no "$1"

echo ""
echo "*** Done checking file $1 ***"
echo ""
