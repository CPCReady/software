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
    echo "Change screen mode or show the current one."
    echo 
    echo "Use: mode [option]"
    echo "  -h, --help     Show this help message."
    echo "  -v, --version  Show version this software."
    echo "Option:"
    echo "  [parameter] Screen Mode [0,1,2] (required)"
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

## Chequeamos si es un proyecto CPCReady
is_cpcready_project

## Leemos las configuraciones del proyecto
read_project_config

# Chequeamos si se ha pasado parametro para crear o mostra nombre imagen
if [ -z "$1" ]; then
    echo -e "${RED}\nOperand missing.${NORMAL}"
    exit 1
fi

## Chequeamos el modo de pantalla de las configuraciones
check_screen_mode "$1"

## Modifica el modo de pantalla en las configuraciones del proyecto.
yq e -i ".mode = $1" "$CONFIG_CPCREADY"

## asignamos un valor de tamaño de fuente en funcion del modo
if [[ "$1" == "0" ]]; then
    size=16
elif [[ "$1" == "1" ]]; then
    size=13
elif [[ "$1" == "2" ]]; then
    size=11
fi
## modificamos el valor del tamaño 
jq --arg size "$size" '.["terminal.integrated.fontSize"] = ($size | tonumber)' "$VSCODE_FOLDER/settings.json" > "$VSCODE_FOLDER/temp.json" && mv "$VSCODE_FOLDER/temp.json" "$VSCODE_FOLDER/settings.json"
## borramos pantalla
clear
exit 0