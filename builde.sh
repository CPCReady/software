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


# # Version MAC
# APPLE_SILICON_VERSION="11"
# APPLE_x86_64_VERSION="10.14"
VERSION="$1"

# function compile {
#     FILENAME="$1"
#     COMPILE_FILE="$FILENAME.c"
#     COMPILE_PATH="bin/$FILENAME"
#     COMPILE_DIST="bin/$FILENAME/dist"
#     COMPILE_SRC="bin/$FILENAME/src"
#     print_start "Compile $FILENAME"
#     if [ -d "$COMPILE_DIST" ]; then
#     # Si el directorio existe, elimínalo
#         rm -rf "$COMPILE_DIST"
#         print_ok "Delete temporal files: $FILENAME"
#     fi
#     mkdir -p "$COMPILE_DIST"
    
#     # Compilar para Apple Silicon (arm64) con macOS 11 como versión mínima
#     clang -target arm64-apple-macos$APPLE_SILICON_VERSION -o "$COMPILE_DIST/$FILENAME"-osx-arm64 "$COMPILE_SRC/$COMPILE_FILE"
#     print_ok "Compile apple silicon: $FILENAME"-osx-arm64
#     # Compilar para Intel (x86_64) con macOS 10.14 como versión mínima
#     clang -target x86_64-apple-macos$APPLE_x86_64_VERSION -o "$COMPILE_DIST/$FILENAME"-osx-x86_64 "$COMPILE_SRC/$COMPILE_FILE"
#     print_ok "Compile apple x86_64: $FILENAME"-osx-x86_64
#     # Crear el binario universal
#     lipo -create -output $COMPILE_DIST/$FILENAME-osx-universal "$COMPILE_DIST/$FILENAME"-osx-arm64 "$COMPILE_DIST/$FILENAME"-osx-x86_64
#     print_ok "Compile apple universal: $FILENAME"-osx-universal
#     x86_64-linux-musl-gcc -o $COMPILE_DIST/$FILENAME-linux-x86_64 "$COMPILE_SRC/$COMPILE_FILE"
#     print_ok "Compile Linux: $FILENAME"-linux-x86_64
#     # Verificar el binario universal
#     # file $COMPILE_DIST/$FILENAME-osx-universal
# }

# borrado temporales
[ -d "$SOURCE/dist" ] && rm -rf "$SOURCE/dist"

# # change version
# echo "$VERSION" > share/VERSION

# # compile c programs
# compile "cat2cpc"
# compile "cpc-config"

# print_start "Compile iDSK+"
# cd $SOURCE/bin/iDSK+
# mkdir -p bin
# make clean
# make
# sleep 3
# lipo -create -output bin/iDSK-osx-universal bin/iDSK
# chmod 777 bin/iDSK*


# # compile amsdospy console
# print_start "Compile amsdospy"
# cd $SOURCE/bin/amsdospy
# print_ok "Change to path $SOURCE/bin/amsdospy"
# # echo "********************************************************"
# # poetry version "$VERSION"
# # poetry build
# # echo "********************************************************"
# # print_ok "Compile amsdospy"
# # SHA256_HASH_AMSDOSPY=$(shasum -a 256 $SOURCE/bin/amsdospy/dist/amsdospy-$VERSION.tar.gz | awk '{ print $1 }')

# gh workflow run publish.yml --repo https://github.com/CPCReady/amsdospy --ref main -f version=$VERSION -f release=true
# sleep 3
# run_id=$(gh run list --repo https://github.com/CPCReady/amsdospy --workflow=publish.yml --branch=main --limit 1 --json databaseId --jq '.[0].databaseId')

# if [ -z "$run_id" ]; then
#   echo "No se pudo obtener el run ID."
#   exit 1
# fi

# gh run watch --repo https://github.com/CPCReady/amsdospy $run_id
# cd dist
# gh release download $VERSION --repo https://github.com/CPCReady/amsdospy --clobber
# SHA256_HASH_AMSDOSPY=$(shasum -a 256 amsdospy-$VERSION.tar.gz | awk '{ print $1 }')

mkdir -p $SOURCE/dist
chmod -R 777 bin
tar -czvf dist/CPCReady-$VERSION.tar.gz bin share
SHA256_HASH_CPCREADY=$(shasum -a 256 $SOURCE/dist/CPCReady-$VERSION.tar.gz | awk '{ print $1 }')
# # Lanzar el workflow
# gh workflow run publish.yml --ref main -f version=1.0.0 -f release=true

# # Esperar unos segundos para asegurarse de que el workflow comience
# sleep 5

# # Obtener el ID del run más reciente
# run_id=$(gh run list --workflow=publish.yml --branch=main --limit 1 --json databaseId --jq '.[0].databaseId')

# if [ -z "$run_id" ]; then
#   echo "No se pudo obtener el run ID."
#   exit 1
# fi

# # Mostrar los logs en tiempo real
# gh run watch $run_id
# git tag -d $VERSION
# git push origin --delete $VERSION

print_start "Login Github"
auth_status=$(gh auth status)

gh release create $VERSION --notes "Primera versión estable" --title "$VERSION"
gh release upload $VERSION dist/CPCReady-$VERSION.tar.gz --clobber

echo -e "${BLUE}*************************************************************************${NC}"
echo -e "${GREEN}AMSDOSPY: ${YELLOW}$SHA256_HASH_AMSDOSPY"
echo -e "${GREEN}CPCREADY: ${YELLOW}$SHA256_HASH_CPCREADY"
echo -e "${BLUE}*************************************************************************${NC}"