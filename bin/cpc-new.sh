#!/bin/bash
##------------------------------------------------------------------------------
##
##        ██████╗██████╗  ██████╗██████╗ ███████╗ █████╗ ██████╗ ██╗   ██╗
##       ██╔════╝██╔══██╗██╔════╝██╔══██╗██╔════╝██╔══██╗██╔══██╗╚██╗ ██╔╝
##       ██║     ██████╔╝██║     ██████╔╝█████╗  ███████║██║  ██║ ╚████╔╝ 
##       ██║     ██╔═══╝ ██║     ██╔══██╗██╔══╝  ██╔══██║██║  ██║  ╚██╔╝  
##       ╚██████╗██║     ╚██████╗██║  ██║███████╗██║  ██║██████╔╝   ██║   
##        ╚═════╝╚═╝      ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═════╝    ╚═╝   
##
##-----------------------------LICENSE NOTICE------------------------------------
##  This file is part of CPCReady - The command line interface (CLI) for 
##  programming Amstrad CPC in Visual Studio Code..
##  Copyright (C) 2024 Destroyer
##
##  This program is free software: you can redistribute it and/or modify
##  it under the terms of the GNU Lesser General Public License as published by
##  the Free Software Foundation, either version 3 of the License, or
##  (at your option) any later version.
##
##  This program is distributed in the hope that it will be useful,
##  This program is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##  GNU Lesser General Public License for more details.
##
##  You should have received a copy of the GNU Lesser General Public License
##  along with this program.  If not, see <http://www.gnu.org/licenses/>.
##------------------------------------------------------------------------------

## define variables y carga funciones
HOMEBREW_PREFIX=$(brew --prefix)
source $HOMEBREW_PREFIX/bin/cpc-library.sh

# Function to display help message
function show_help {
    echo
    echo "Create a CPCReady project."
    echo 
    echo "Use: new [option]"
    echo "  -h, --help     Show this help message."
    echo "  -v, --version  Show version this software."
    echo "Option:"
    echo "  [parameter] Project Name (required)"
    ready
}

# Check if the help parameter is provided
case $1 in
    -v|--version)
        cpc-about.sh
        exit 0
        ;;
    -h|--help)
        show_help
        exit 0
        ;;
esac

# Verifica si se ha pasado el nombre de proyecto
if [ -z "$1" ]; then
    echo -e "\n${RED}${BOLD}Param Project name required.${NORMAL}" 1>&2
    show_help
    exit 1
fi

## Eliminar espacios en blanco
PROJECT_PATH=$(replace_spaces "$1")
PROJECT_NAME=$(basename "$PROJECT_PATH")

## Verificar si el proyecto ya existe
result=$(check_path_existence "$PROJECT_PATH")
if [ "$result" == "true" ]; then
    echo -e "\n${RED}${BOLD}Project $PROJECT_NAME already exists."
    exit 1
fi

## Creamos carpetas del proyecto
mkdir -p "$PROJECT_PATH"
mkdir -p "$PROJECT_PATH/$SRC_FOLDER"
mkdir -p "$PROJECT_PATH/$OUT_FILES"
mkdir -p "$PROJECT_PATH/$OUT_DISC"
mkdir -p "$PROJECT_PATH/$TMP_FOLDER"
mkdir -p "$PROJECT_PATH/$VSCODE_FOLDER"

## Creamos configuracion del proyecto
echo "" >"$PROJECT_PATH/$CONFIG_CPCREADY"
yq e -i ".project = \"$PROJECT_NAME\"" "$PROJECT_PATH/$CONFIG_CPCREADY"
yq e -i ".disc = \"$PROJECT_NAME.dsk\"" "$PROJECT_PATH/$CONFIG_CPCREADY"
yq e -i ".model =6128" "$PROJECT_PATH/$CONFIG_CPCREADY"
yq e -i ".mode =1" "$PROJECT_PATH/$CONFIG_CPCREADY"

## Creamos DISC.BAS
current_datetime=$(get_current_datetime)
current_version=$(get_version)
jinja2 --format=json $HOMEBREW_PREFIX_SHARE/DISC.j2 -D project="$PROJECT_NAME" -D current_datetime="$current_datetime" -D version="$current_version"> "$PROJECT_PATH/$SRC_FOLDER/DISC.BAS"

## Creamos Retro Virutal Machen Web
jinja2 --format=json $HOMEBREW_PREFIX_SHARE/RetroVirtualMachine.j2 -D project="$PROJECT_NAME" -D DISC="$PROJECT_NAME.dsk" > "$PROJECT_PATH/RetroVirtualMachine.html"

# Obtener el nombre del sistema operativo
os_name=$(uname)

# Verificar el sistema operativo
if [[ "$os_name" == "Linux" ]]; then
    jinja2 --format=json $HOMEBREW_PREFIX_SHARE/settings.j2 -D SYSTEM="linux" > "$PROJECT_PATH/$VSCODE_FOLDER/settings.json"
elif [[ "$os_name" == "Darwin" ]]; then
    jinja2 --format=json $HOMEBREW_PREFIX_SHARE/settings.j2 -D SYSTEM="osx" > "$PROJECT_PATH/$VSCODE_FOLDER/settings.json"
else
   echo -e "${RED}${BOLD} $os_name System not supported. ${NORMAL}"
fi

## Creamos imagen de disco
create_disc_image $PROJECT_PATH/$OUT_DISC/$PROJECT_NAME.dsk

## Mostramos mensaje
PATH_PROJECT=$(dirname "$PWD/$PROJECT_PATH")
echo -e "${WHITE}${BOLD}\nCreated project${GREEN} $PROJECT_NAME ${WHITE}${BOLD}in${GREEN}${BOLD} $PATH_PROJECT"

## Comprobamos si esta configurado el emulador
result=$(check_path_existence "$HOME/.CPCReady/emulators.yaml")
if [ "$result" == "false" ]; then
    mkdir -p "$HOME/.CPCReady"
    echo "" > "$HOME/.CPCReady/emulators.yaml"
    yq e -i ".RetroVirtualMachine_Path = \"\"" "$HOME/.CPCReady/emulators.yaml"
    echo -e "\n${YELLOW}${BOLD}CPCReady does not have the RetroVirtualMachine Emulator path configured."
    echo -e "Please set the path to $HOME/.CPCReady/emulators.yaml"
    exit 0
fi
