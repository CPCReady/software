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

## Function to display help message
function show_help {
    CPCREADY
    echo "Change CPC Model."
    echo 
    echo "Use: model [option]"
    echo "  -h, --help     Show this help message."
    echo "  -v, --version  Show version this software."
    echo "Option:"
    echo "  [parameter] Amstrad CPC Models. Options values [464,664,6128]."
    echo "              If the parameter is empty, shows the"
    echo "              current value."
}

## Check if the help parameter is provided
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

## Chequeamos si existe el archivo de variables.
## si no existe salimos con error
check_env_file

## Cargamos archivo de variables
source "$PATH_CONFIG_PROJECT/$CONFIG_CPCREADY"


## Check if the parameter is empty
if [ -z "$1" ]; then
    evaluaCPCModel $MODEL
    clear
    model_cpc $MODEL
    exit 0
fi

# Comprobamos Modelo CPC
evaluaCPCModel $1

case $1 in
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

cpc-config "$PATH_CONFIG_PROJECT/$CONFIG_CPCEMU" CPC_TYPE $MODEL
cpc-config "$PATH_CONFIG_PROJECT/$CONFIG_CPCREADY" MODEL $1

clear
model_cpc $1





