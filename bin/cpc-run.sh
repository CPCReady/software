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
source "$HOMEBREW_PREFIX/bin/cpc-library.sh"

# Function to display help message
function show_help {
    echo
    echo "Run files in emulator."
    echo 
    echo "Use: run [option]"
    echo "  -h, --help     Show this help message."
    echo "  -v, --version  Show version this software."
    echo "Option:"
    echo "  [parameter] File name (optional)"
    echo "              If not, if you pass the parameter, "
    echo "              the file to be executed in the emulator is DISC.BAS"
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

## Mostramos cabecera
TITLE=$(middle_tittle "Run disk image $disc")
echo -e "\n===================================================================="
echo -e "${WHITE}** ${GREEN}${BOLD}$TITLE ${WHITE}**${NORMAL}"
echo -e "===================================================================="

# Ruta al archivo YAML
is_defined="false"
yaml_file="$HOME/.CPCReady/emulators.yaml"
## Verificar si el emulador existe
result=$(check_path_existence "$yaml_file")
echo
if [ "$result" == "true" ]; then
    RVM=$(yq e '.RetroVirtualMachine_Path' "$yaml_file")
    sistema_operativo="$(uname)"
    if [ "$sistema_operativo" == "Darwin" ]; then
        RVM="$RVM/Contents/MacOS/Retro Virtual Machine 2"
    else
        RVM="$RVM"
    fi
    result=$(check_path_existence "$RVM")
    if [ "$result" == "true" ]; then
        is_defined="true"
        log "OK" "${WHITE}RetroVirtualMachine${NORMAL} path is defined."
    else
        log "WARNING" "${WHITE}RetroVirtualMachine${NORMAL} path is not defined."
    fi
else
    log "WARNING" "${WHITE}RetroVirtualMachine${NORMAL} path is not defined."
fi

## Definimos comando a ejecutar
if [ -z "$1" ]; then
    COMMAND="DISC.BAS"
else
    COMMAND="$1"
    COMMAND=${COMMAND//\"/}
fi

log "OK" "CPC Model Selected: ${WHITE}$model${NORMAL}"
log "OK" "Image Dsk: ${WHITE}$disc${NORMAL}"

if [ "$is_defined" == "true" ]; then

    "$RVM" -b=cpc"$model" -i "$OUT_DISC/$disc" -c="run\"$COMMAND\"\n" > /dev/null 2>&1 &
    ## Verifica el código de salida del comando
    if [ $? -ne 0 ]; then
        log "ERROR" "An error occurred while running the image in the emulator."
        exit 1
    fi
    OK "COMMAND" "Execute $COMMAND"
else
    ## Creamos Retro Virtual Machen Web
    jinja2 --format=json "$HOMEBREW_PREFIX_SHARE/RetroVirtualMachine.j2" -D command="$COMMAND" -D project="$project" -D DISC="$OUT_DISC/$disc" > "RetroVirtualMachine.html"
    log "WARNING" "${WHITE}RetroVirtualMachine${NORMAL} generated in ${WHITE}RetroVirtualMachine.html${NORMAL}"
fi

TITLE=$(middle_tittle "Run image Successfully")
echo -e "\n===================================================================="
echo -e "${WHITE}** ${GREEN}${BOLD}$TITLE ${WHITE}**${NORMAL}"
echo -e "===================================================================="
exit 0
