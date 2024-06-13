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
# shellcheck disable=SC2154
TITLE=$(middle_tittle "Generating disk image of the $project project")
echo -e "\n===================================================================="
echo -e "${WHITE}** ${GREEN}${BOLD}$TITLE ${WHITE}**${NORMAL}"
echo -e "===================================================================="

## volvemos a crear las carpetas
mkdir -p "$OUT_FILES"

## Creamos imagen de disco
create_disc_image $OUT_DISC/$DISC
echo
log "OK" "DISK" "Create disk image $DISC."
## Si no pasamos parametro asumimos que hay que crear 
## la imagen DSK de todos los archivos de src
if [ -z "$1" ]; then
    ## Add files BAS to disk image
    for archivo in "$SRC_FOLDER"/*.BAS "$SRC_FOLDER"/*.bas; do
        if [ -f "$archivo" ]; then
            file=$(basename "$archivo")
            check_file_83 $file
            delete_comments "$archivo" "$OUT_FILES/$file"
            ## convert unix2dos
            archive=$(adjust_string "$file")
            unix2dos $OUT_FILES/$file >/dev/null 2>&1
            if [ $? -eq 0 ]; then
                # OK "$file" "Converting file to DOS format."
                log "OK" "$file" "Converting file to DOS format."
            else
                log "ERROR" "$file" "There was a problem converting the file to DOS format."
                exit 1
            fi
            ## add file to dsk image
            add_file_to_disk_image $OUT_DISC/$DISC $OUT_FILES/$file
        fi
    done
else
    file="$1"
    file=${file//\"/}
    ## Comprobamos si existe el fichero
    result=$(check_path_existence "$SRC_FOLDER/$file")
    if [ "$result" == "true" ]; then
        check_file_83 $file
        delete_comments "$SRC_FOLDER/$file" "$OUT_FILES/$file"
        ## convert unix2dos
        archive=$(adjust_string "$file")
        unix2dos $OUT_FILES/$file >/dev/null 2>&1
        if [ $? -eq 0 ]; then
            OK $file "Converting file to DOS format."
        else
            ERROR $file "There was a problem converting the file to DOS format."
        fi
        ## add file to dsk image
        add_file_to_disk_image $OUT_DISC/$DISC $OUT_FILES/$file
    else
        ERROR $file "Not found."
        exit 1
    fi
fi

TITLE=$(middle_tittle "Disk image generated Successfully")
echo -e "\n===================================================================="
echo -e "${WHITE}** ${GREEN}${BOLD}$TITLE ${WHITE}**${NORMAL}"
echo -e "===================================================================="
exit 0

