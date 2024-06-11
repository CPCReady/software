#!/bin/bash

set -e


# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
WHITE='\033[0;37m'
NC='\033[0m' # Sin color
SOURCE=$PWD

# Función para imprimir en verde
print_ok() {
    echo -e "${WHITE}[${GREEN}   OK    ${WHITE}] $1${NC}"
}

print_start() {
    echo -e "${WHITE}[${GREEN}  START  ${WHITE}] ${BLUE}$1${NC}"
}

print_error () {
    echo
    echo -e "${WHITE}[${RED} ERROR  ${WHITE}] $1${NC}"
    echo
}

print_warning () {
    echo
    echo -e "${WHITE}[${YELLOW} WARNING ${WHITE}] $1${NC}"
    echo
}

if [ $# -eq 0 ]; then
    print_error "Error: No se pasó Version."
    echo "Uso: $0 <version>"
    exit 1
fi

mkdir -p dist
# # Version MAC
# APPLE_SILICON_VERSION="11"
# APPLE_x86_64_VERSION="10.14"
VERSION="$1"
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

gh workflow run publish.yml --repo https://github.com/CPCReady/software --ref $CURRENT_BRANCH -f version=$VERSION -f release=true
sleep 1
run_id=$(gh run list --repo https://github.com/CPCReady/software --workflow=publish.yml --branch=$CURRENT_BRANCH --limit 1 --json databaseId --jq '.[0].databaseId')

if [ -z "$run_id" ]; then
  echo "No se pudo obtener el run ID."
  exit 1
fi

gh run watch --repo https://github.com/CPCReady/software $run_id
cd dist
gh release download $VERSION --repo https://github.com/CPCReady/software --clobber
SHA256_HASH_AMSDOSPY=$(shasum -a 256 CPCReady-$VERSION.tar.gz | awk '{ print $1 }')