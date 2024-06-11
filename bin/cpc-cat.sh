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
    echo "List files in disc image."
    echo 
    echo "Use: cat"
    echo "  -h, --help     Show this help message."
    echo "  -v, --version  Show version this software."
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

## Chequeamos si es un proyecto CPCReady
is_cpcready_project

## Leemos las configuraciones del proyecto
read_project_config

## Obtenemos el tamaño en KB de los ficheros
total_KB=$(iDSK $OUT_DISC/$DISC -l | sed -e 's/://g' -e 's/ Ko/K/g' | awk '{sum += $3} END {print sum}')
free_KB=$((178 - total))

## Mostramos el contenido de la imagen
echo -e "Drive A: $DISC"
exit_result=$(iDSK $OUT_DISC/$DISC -l | sed -e 's/://g' -e 's/ Ko/K/g')
if [[ ! "$exit_result" =~ "Fichier image non supporter" ]]; then
    echo "$exit_result"
fi
echo -e "\n${free_KB}K free"
exit 0
