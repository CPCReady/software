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

## Monstramos cabezera
TITLE=$(middle_tittle "Run disk image $disc")
echo -e "\n${YELLOW}${BOLD}====================================================================${NORMAL}"
echo -e "${WHITE}${BOLD}** $TITLE **"
echo -e "${YELLOW}${BOLD}====================================================================${NORMAL}"

# Ruta al archivo YAML
is_defined="false"
yaml_file="$HOME/.CPCReady/emulators.yaml"
## Verificar si el emulador existe
result=$(check_path_existence "$yaml_file")
echo
if [ "$result" == "true" ]; then
    RVM=$(yq e '.RetroVirtualMachine_Path' $yaml_file)
    sistema_operativo="$(uname)"
    if [ "$sistema_operativo" == "Darwin" ]; then
        RVM="$RVM/Contents/MacOS/Retro Virtual Machine 2"
    else
        RVM="$RVM"
    fi
    result=$(check_path_existence "$RVM")
    if [ "$result" == "true" ]; then
        is_defined="true"
        OK "Emulator" "RetroVirtualMachine path is defined."
    else
        WARNING "Emulator" "RetroVirtualMachine path is not defined."
    fi
else
    WARNING "Emulator" "RetroVirtualMachine path is not defined."
fi

## Definimos comando a ejecutar
if [ -z "$1" ]; then
    COMMAND="DISC.BAS"
else
    COMMAND="$1"
fi

    OK "CPC" "Model selected: $model"
    OK "DISK" "Image Dsk: $disc"

if [ "$is_defined" == "true" ]; then

    "$RVM" -b=cpc"$model" -i "$OUT_DISC/$disc" -c="run\"$COMMAND\"\n" > /dev/null 2>&1 &
    ## Verifica el código de salida del comando
    if [ $? -ne 0 ]; then
        ERROR "Emulador" "An error occurred while running the image in the emulator."
        exit 1
    fi
    OK "COMMAND" "Execute $COMMAND"
else
    ## Creamos Retro Virutal Machen Web
    jinja2 --format=json $HOMEBREW_PREFIX_SHARE/RetroVirtualMachine.j2 -D command="$COMMAND" -D project="$PROJECT_NAME" -D DISC="$OUT_DISC/$disc" > "RetroVirtualMachine.html"
    WARNING "Emulator" "RetroVirtualMachine generated in RetroVirtualMachine.html"
fi

TITLE=$(middle_tittle "Run image Successfully")
echo -e "\n${YELLOW}${BOLD}====================================================================${NORMAL}"
echo -e "${GREEN}${BOLD}** $TITLE **"
echo -e "${YELLOW}${BOLD}====================================================================${NORMAL}"
exit 0


exit


## define variables y carga funciones
HOMEBREW_PREFIX=$(brew --prefix)
source $HOMEBREW_PREFIX/bin/cpc-library.sh

# Allowed values for the emulator parameter
emulators=("m4" "rvm")

# Function to display help message
function show_help {

    CPCREADY
    echo "Run Files in Emulator"
    echo 
    echo "Use: run [option]"
    echo "  -h, --help     Show this help message."
    echo "  -v, --version  Show version this software."
    echo "Option:"
    echo "  [parameter]  File Name. If there is no parameter, "
    echo "               it uses DISC.BAS by default."
}

## Chequeamos si existe el archivo de variables.
## si no existe salimos con error
check_env_file

## Cargamos archivo de variables
source "$PATH_CONFIG_PROJECT/$CONFIG_CPCREADY"

# Check if the help parameter is provided
# Process command line options
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

if [[ "$OSTYPE" == "linux-gnu" ]]; then
    CPCEMU="$HOMEBREW_PREFIX/share/cpcemu/cpcemu"
    RVM="$HOMEBREW_PREFIX/share/RetroVirtualMachine"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    CPCEMU="$HOMEBREW_PREFIX/share/CPCemuMacOS.app/Contents/MacOS/CPCemuMacOS"
    RVM="$HOMEBREW_PREFIX/share/RetroVirtualMachine2.app/Contents/MacOS/RetroVirtualMachine2"
else
    PRINT ERROR "$OSTYPE Operating system NOT supported."
fi

EMULATOR=$(echo "$EMULATOR" | tr '[:upper:]' '[:lower:]')

echo
if [[ "$EMULATOR" == "m4" ]]; then
    check_83_files_path "$OUT"
    PRINT "OK" "Emulator: CPCEmu."
    PRINT "OK" "Project execute in SD."
    $CPCEMU -f -c "$PWD/$PATH_CONFIG_PROJECT/$CONFIG_CPCEMU" > /dev/null 2>&1 &
elif [[ "$EMULATOR" == "rvm" ]]; then
    if [ ! -e "$OUT_DISC/$DISC" ]; then
        PRINT "ERROR" "$OUT_DISC/$DISC not found."
    fi
    # Si no pasamos argumento ejecutamos DISC.BAS

    if [ -z "$1" ]; then
        BAS_FILE="DISC.BAS"
    else
        BAS_FILE="$1"
    fi

    PRINT "OK" "Emulator: RetroVirtualMachine."
    PRINT "OK" "DISC: $DISC"
    PRINT "OK" "run\"$BAS_FILE\""
    $RVM -b=cpc$MODEL -i "$OUT_DISC/$DISC" -c='run"'$BAS_FILE'\n' > /dev/null 2>&1 &
fi    
