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
source $HOMEBREW_PREFIX/bin/cpc.lib

# Function to display help message
function show_help {

    echo "Create a CPCReady project."
    echo 
    echo "Use: new [option] Project Name"
    echo "  -h, --help     Show this help message."
    echo "  -v, --version  Show version this software."
    ready
}

# Check if the help parameter is provided
case $1 in
    -v|--version)
        show_version
        exit 0
        ;;
    -h|--help)
        show_help
        exit 0
        ;;
esac

# Verifica si se ha pasado el nombre de proyecto
if [ -z "$1" ]; then
    echo -e "\nNot enough arguments (missing: "Project Name")"
    show_help
    exit 1
fi


if [ -e ./"$CONFIG_CPCREADY" ]; then
    echo -e "\nProject {project} already exists."
    exit
fi

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