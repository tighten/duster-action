#!/bin/sh -l

set -e

echo "Running: duster" $*

duster --version
duster $*
