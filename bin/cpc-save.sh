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
    echo "Create disk image with project files."
    echo 
    echo "Use: save [option]"
    echo "  -h, --help     Show this help message."
    echo "  -v, --version  Show version this software."
    echo "Option:"
    echo "  [parameter] File name (optional)"
    echo "              If no parameter is passed, a disk image is "
    echo "              generated with all the project files."
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

## Chequeamos si es un proyecto CPCReady
is_cpcready_project

## Leemos las configuraciones del proyecto
read_project_config

## chequeamos nomenclatura es correcta
check_83_files_path $SRC_FOLDER

## volvemos a crear las carpetas
mkdir -p "$OUT_FILES"

## Creamos imagen de disco
create_disc_image $OUT_DISC/$DISC

## Si no pasamos parametro asumimos que hay que crear 
## la imagen DSK de todos los archivos de src
if [ -z "$1" ]; then
    ## Add files BAS to disk image
    for archivo in "$SRC_FOLDER"/*.BAS "$SRC_FOLDER"/*.bas; do
        if [ -f "$archivo" ]; then
            file=$(basename "$archivo")
            delete_comments "$archivo" "$OUT_FILES/$file"
            ## convert unix2dos
            unix2dos "$OUT_FILES/$file" >/dev/null 2>&1; echo -e "Converting file to DOS format." || echo "${RED}${BOLD}There was a problem converting the file to DOS format."
            ## add file to dsk image
            add_file_to_disk_image "$OUT_DISC/$DISC" "$OUT_FILES/$file"
        fi
    done
    exit 0
else
    file="$1"
    ## Comprobamos si existe el fichero
    result=$(check_path_existence "$SRC_FOLDER/$file")
    if [ "$result" == "true" ]; then
        delete_comments "$SRC_FOLDER/$file" "$OUT_FILES/$file"
        ## convert unix2dos
        unix2dos "$OUT_FILES/$file" >/dev/null 2>&1; echo -e "Converting file to DOS format." || echo "${RED}${BOLD}There was a problem converting the file to DOS format."
        ## add file to dsk image
        add_file_to_disk_image "$OUT_DISC/$DISC" "$OUT_FILES/$file"
        exit 0
    else
        echo -e "${RED}\n$file Not found.${NORMAL}"
    fi
fi

exit 0

