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
##  This file is part of CPCReady Basic programation.
##  Copyright (C) 2024 Destroyer
##
##  This program is free software: you can redistribute it and/or modify
##  it under the terms of the GNU Lesser General Public License as published by
##  the Free Software Foundation, either version 3 of the License, or
##  (at your option) any later version.
##
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
    echo "Use: new [option] Project"
    echo "  -h, --help     Show this help message."
    echo "  -v, --version  Show version this software."
    echo "Option:"
    echo "  [parameter] Project Name"
    ready
}

# Check if the help parameter is provided
case $1 in
    -v|--version)
        cpcready_logo
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
result=$(check_path_existence "$PROJECT")
if [ "$result" == "true" ]; then
    echo -e "\n${RED}${BOLD}Project $PROJECT already exists."
    exit 1
fi

mkdir -p "$PROJECT_PATH"
mkdir -p "$PROJECT_PATH/$SRC_FOLDER"
mkdir -p "$PROJECT_PATH/$OUT_FILES"
mkdir -p "$PROJECT_PATH/$OUT_DISC"
mkdir -p "$PROJECT_PATH/$TMP_FOLDER"
mkdir -p "$PROJECT_PATH/$VSCODE_FOLDER"

echo "" >"$PROJECT_PATH/$CONFIG_CPCREADY"
yq e -i ".project = \"$PROJECT_NAME\"" "$PROJECT_PATH/$CONFIG_CPCREADY"
yq e -i ".disc = \"$PROJECT_NAME.dsk\"" "$PROJECT_PATH/$CONFIG_CPCREADY"
yq e -i ".model =6128" "$PROJECT_PATH/$CONFIG_CPCREADY"
yq e -i ".mode =1" "$PROJECT_PATH/$CONFIG_CPCREADY"

current_datetime=$(get_current_datetime)
current_version=$(get_version)
jinja2 --format=json $HOMEBREW_PREFIX_SHARE/DISC.j2 -D project="$PROJECT_NAME" -D current_datetime="$current_datetime" -D version="$current_version"> "$PROJECT_PATH/$SRC_FOLDER/DISC.BAS"


exit
while true; do
    echo
    read -p "${BLUE}${BOLD} Project's name: ${NORMAL}" project_name

    # Reemplazar espacios por guiones bajos
    project_name=${project_name// /_}

    if [[ -z "$project_name" ]]; then
        echo
        PRINT "ERROR_NO_EXIT" "The project name cannot be empty."
    elif [[ -d "./$project_name" ]]; then
        echo
        PRINT "ERROR_NO_EXIT" "A directory with the name '$project_name' already exists. Please choose another name."
    else
        break
    fi
done
while true; do
    read -p "${BLUE}${BOLD} CPC Model (464, 664, or 6128): ${NORMAL}" cpc_model

    case $cpc_model in
        464|6128|664)
            break
            ;;
        *)
            echo
            PRINT "ERROR_NO_EXIT" "Invalid CPC Model. Please choose either 464, 664, or 6128."
            echo
            ;;
    esac
done


while true; do
    read -p "${BLUE}${BOLD} Run test in (M4 / RVM)?: " respuesta
    case "$respuesta" in
        [Mm]4*|[Bb]oard*)  TEST="m4";break;;
        [Rr][Vv][Mm]*) TEST="rvm";break;;
        *) echo "${RED}${BOLD} Please respond with 'M4' or 'DISC'.";;
    esac
done

while true; do
    read -p "${BLUE}${BOLD} Apply native Amstrad CPC colors to the Visual Studio Code terminal? (y/n): " respuesta
    case $respuesta in
        [Yy]* ) AMSTRAD_COLORS="S";break;;
        [Nn]* ) AMSTRAD_COLORS="N";break;;
        * ) echo "${RED}${BOLD}  Please respond with 'y' or 'n'.";;
    esac
done


## Create the project directory
PRINT "TAG" "Directory"
mkdir -p "$project_name/$IN_BAS"
mkdir -p "$project_name/$OUT"
mkdir -p "$project_name/$OUT_DISC"
mkdir -p "$project_name/$OUT_TAPE"
mkdir -p "$project_name/$PATH_CONFIG_PROJECT"
PRINT "OK" "Create the $project_name directory."

## Create Templates files
PRINT "TAG" "Template File"
template_bas "$project_name/$IN_BAS/DISC.BAS"
# cp -r "$CPCREADY/cfg/templates/DISC.BAS" "$project_name/$IN_BAS/DISC.BAS"
PRINT "OK" "Create template example DISC.BAS file."

## Create configuration file
PRINT "TAG" "Configurations"

touch "$project_name/$PATH_CONFIG_PROJECT/$CONFIG_CPCREADY"
template_cpcemu "$project_name/$PATH_CONFIG_PROJECT/$CONFIG_CPCEMU"

case $cpc_model in
    "464")
        MODEL=0
        ;;
    "664")
        MODEL=1
        ;;
    "6128")
        MODEL=2
        ;;
    *)
        PRINT ERROR "CPC model $1 is not supported."
        ;;
esac

cpc-config "$PWD/$project_name/$PATH_CONFIG_PROJECT/$CONFIG_CPCEMU" CPC_TYPE $MODEL
cpc-config "$PWD/$project_name/$PATH_CONFIG_PROJECT/$CONFIG_CPCREADY" MODEL $cpc_model
PRINT OK "Configurate CPC Model $cpc_model"

cpc-config "$PWD/$project_name/$PATH_CONFIG_PROJECT/$CONFIG_CPCEMU" PRINTER "$PWD/$project_name/$PATH_CONFIG_PROJECT/PRN"
cpc-config "$PWD/$project_name/$PATH_CONFIG_PROJECT/$CONFIG_CPCEMU" M4_SD_PATH "$PWD/$project_name/$OUT"
PRINT OK "Configurate M4 Board Directory $OUT"

cpc-config "$PWD/$project_name/$PATH_CONFIG_PROJECT/$CONFIG_CPCEMU" TAPE_PATH "$PWD/$project_name/$OUT_TAPE"
cpc-config "$PWD/$project_name/$PATH_CONFIG_PROJECT/$CONFIG_CPCEMU" DRIVE_A "$PWD/$project_name/$OUT_DISC"
cpc-config "$PWD/$project_name/$PATH_CONFIG_PROJECT/$CONFIG_CPCEMU" DRIVE_B "$PWD/$project_name/$OUT_DISC"
cpc-config "$PWD/$project_name/$PATH_CONFIG_PROJECT/$CONFIG_CPCREADY" DISC "$project_name.dsk"
PRINT OK "Configurate DISC Directory $OUT_DISC"

# creamos vscode para cambios de color de la terminal.
if [ "$AMSTRAD_COLORS" = "S" ]; then
    mkdir -p "$project_name/.vscode"
    if [[ "$OSTYPE" == "linux-gnu" ]]; then
        template_settings "linux" "$project_name/.vscode/settings.json"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        template_settings "osx" "$project_name/.vscode/settings.json"
    else
        PRINT ERROR "$OSTYPE Operating system NOT supported."
    fi
    PRINT "OK" "Apply colors to the Vscode terminal."
fi

cpc-config "$PWD/$project_name/$PATH_CONFIG_PROJECT/$CONFIG_CPCREADY" MODE 1
cpc-config "$PWD/$project_name/$PATH_CONFIG_PROJECT/$CONFIG_CPCREADY" EMULATOR $TEST

PRINT OK "Configure test execution with $TEST"

if which amstrad >/dev/null; then
    PRINT OK "Activate Amstrad console for Visual Studio Code."
else
    if [[ "$OSTYPE" == "linux-gnu" ]]; then
        jq 'del(.["terminal.integrated.defaultProfile.linux", "terminal.integrated.profiles.linux"])' $project_name/.vscode/settings.json > $project_name/.vscode/temp.json && mv $project_name/.vscode/temp.json $project_name/.vscode/settings.json
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        jq 'del(.["terminal.integrated.defaultProfile.linux", "terminal.integrated.profiles.linux"])' $project_name/.vscode/settings.json > $project_name/.vscode/temp.json && mv $project_name/.vscode/temp.json $project_name/.vscode/settings.json
    else
        PRINT ERROR "$OSTYPE Operating system NOT supported."
    fi    
    PRINT WARNING "There is no Amstrad Console on the system."
    PRINT WARNING "Disabled the Amstrad Console for Visual Studio Code."
fi

## Create image disk file
create_dsk "$PWD/$project_name/$OUT_DISC/$project_name.dsk"

PRINT "TITLE" "Project Created Successfully"

ready