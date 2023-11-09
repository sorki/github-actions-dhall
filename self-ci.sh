#!/usr/bin/env bash
# Script by @fisx

set -eo pipefail
cd "$( dirname "${BASH_SOURCE[0]}" )"

echo "regenerating .github/workflows/dhall.yaml..."

dhall-to-yaml --file self-ci.dhall > .github/workflows/dhall.yaml
