#!/bin/bash


SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

set -e

chown :build "${SCRIPT_DIR}/../yocto/"
chmod 775 "${SCRIPT_DIR}/../yocto/"
chmod g+s "${SCRIPT_DIR}/../yocto/"

