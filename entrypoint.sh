#!/bin/sh

set -e

echo "Running: duster" $*

duster --version
duster $*
