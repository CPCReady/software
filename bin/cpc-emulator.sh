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
    echo "Change Emulator."
    echo 
    echo "Use: emulator [option]"
    echo "  -h, --help     Show this help message."
    echo "  -v, --version  Show version this software."
    echo "Option:"
    echo "  [parameter] Supported Emulators. Options values ["m4","rvm"]."
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
    evaluaEmulator $EMULATOR
    echo
    PRINT "OK" "Emulator Selected is $EMULATOR"
    exit 0
fi

# Comprobamos Emuladores soportados
evaluaEmulator $1
cpc-config "$PATH_CONFIG_PROJECT/$CONFIG_CPCREADY" EMULATOR $1
echo
PRINT "OK" "Changed Emulator $1"





