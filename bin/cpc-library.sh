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

## VARIABLES COLORES

RED=$'\033[0;31;49m'
GREEN=$'\033[38;5;040m'
BG_BLUE=$'\033[44m'
MAGENTA=$'\033[0;35;49m'
BLUE=$'\033[38;5;033m'
CYAN=$'\033[0;36;49m'
YELLOW=$'\033[0;33;49m'
WHITE=$'\033[0;37;49m'
NORMAL=$'\033[0;39;49m'
BOLD="$(tput bold)"

## VARIABLES PROYECTOS
PATH_VERSION_FILE="$HOMEBREW_PREFIX/share/VERSION"
HOMEBREW_PREFIX_SHARE="$HOMEBREW_PREFIX/share"
SRC_FOLDER="src"
OUT_FILES="out/files"
OUT_DISC="out"
OUT_TAPE="out"
TMP_FOLDER="tmp"
VSCODE_FOLDER=".vscode"
CONFIG_CPCREADY="CPCReady.yml"

##
## obtiene las configuraciones del proyecto
## como variables de entorno.
##
##   Returns:
##       string(): variables de entorno
##

function read_project_config(){
  # Ruta al archivo YAML
  yaml_file="$CONFIG_CPCREADY"

  # Leer los valores del archivo YAML usando yq
  project=$(yq e '.project' $yaml_file)
  disc=$(yq e '.disc' $yaml_file)
  model=$(yq e '.model' $yaml_file)
  mode=$(yq e '.mode' $yaml_file)

  # Exportar las variables como variables de entorno
  export PROJECT="$project"
  export DISC="$disc"
  export MODEL="$model"
  export MODE="$mode"

}

##
## obtiene la version
##
##   Returns:
##       string(): version
##

function get_version(){
  version=$(cat $PATH_VERSION_FILE)
  echo $version
}

##
## Muestra el logo con la version
##
##   Returns:
##       string(): version
##

function cpcready_logo {
   echo
   VERSION=$(get_version)
   echo "${WHITE}╔═╗╔═╗╔═╗  ┌──────────┐"
   echo "${WHITE}║  ╠═╝║    │ ${NORMAL}${RED}██ ${GREEN}██ ${BLUE}██${NORMAL} │"
   echo "${WHITE}╚═╝╩  ╚═╝  └──────────┘"

   echo "Ready" >&2
   echo "█" >&2
   echo "${NORMAL}"
}

##
## Reemplaza espacios por _ 
##
##   Args:
##       file (str): nombre de fichero
##

function replace_spaces() {
    local input_string="$1"
    local output_string="${input_string// /_}"
    echo "$output_string"
}

##
## Verifica si estamos en un proyecto CPCReady 
##
##   Args:
##       file (str): nombre de fichero
##

function is_cpcready_project {
   if [ ! -f "$CONFIG_CPCREADY" ]; then
      echo -e "${RED}\nThis software can only be used in a CPCReady project.${NORMAL}"
      exit 1
   fi
}

##
## Verifica si existe una carpeta o fichero
##
##   Args:
##       folder_path (str): path o ruta de la carpeta o fichero
##
##   Returns:
##       bool: True si existe, False si no existe
##

function check_path_existence() {
    local path="$1"

    if [ -e "$path" ]; then
        echo "true"
        return 0
    else
        echo "false"
        return 1
    fi
}

##
## Obtine la fecha y la hora actuales
##
##   Returns:
##       string(): fecha y hora actuales
##

function get_current_datetime(){
  fecha_y_hora=$(date +"%Y-%m-%d %H:%M:%S")
  echo "$fecha_y_hora"
}

##
## Crea imagen de disco vacia
##
##   Args:
##       image_name (str): path o ruta de la imagen de disco a crear
##   Returns:
##       error: 0 ok <> Error
##

function create_disc_image {
    local DSK_IMAGE="$1"
    ## Ejecuta el comando
    iDSK "$DSK_IMAGE" -n > /dev/null 2>&1

    ## Verifica el código de salida del comando
    if [ $? -ne 0 ]; then
        ERROR "DSK IMAGE" "There was an error creating the disk image."
    fi
}

##
## Verifica que el modo de pantalla sea correcto
##
##   Args:
##       Screen Mode (str): Modo de pantalla (0,1,2)
##   Returns:
##       error: 0 ok <> Error
##
function check_screen_mode {
   # pantallas soportadas
   lista=("0" "1" "2")
   for elemento in "${lista[@]}"; do
      if [[ "$elemento" == "$1" ]]; then
         return
      fi
   done
   echo -e "${RED}\nImproper argument.${NORMAL}"
   exit 1
}

##
## Verifica que el modelo de CPC sea correcto
##
##   Args:
##       CPC Model (str): Modo de pantalla (464,664,6128)
##   Returns:
##       error: 0 ok <> Error
##

function check_cpc_model {
   # modelos soportados
   lista=("464" "664" "6128")
   for elemento in "${lista[@]}"; do
      if [[ "$elemento" == "$1" ]]; then
         return
      fi
   done
   echo -e "${RED}\nImproper argument.${NORMAL}"
   exit 1
}

##
## muestra el modelo de cpc
##
##   Args:
##       CPC Model (str): Modo de pantalla (464,664,6128)
##   Returns:
##       error: 0 ok <> Error
##

function show_model_cpc {
case $1 in
    6128)
echo """ 
 Amstrad 128K Microcomputer    (v3)
 ©1985 Amstrad Consumer Electronics plc
         and Locomotive Software Ltd.

 BASIC 1.1
 ${NORMAL}"""
        ;;
    664)
echo """ 
 Amstrad 64K Microcomputer    (v2)
 ©1984 Amstrad Consumer Electronics plc
         and Locomotive Software Ltd.

 BASIC 1.1
 ${NORMAL}"""
        ;;
    464)
echo """ 
 Amstrad 64K Microcomputer    (v1)
 ©1984 Amstrad Consumer Electronics plc
         and Locomotive Software Ltd.

 BASIC 1.0
 ${NORMAL}"""
        ;;
esac
}

##
## Chequeamos si todos los archivos del proyecto cumplen
## la norma 8:3
##
##   Returns:
##       error: 0 ok <> Error
##

check_file_83() {
    local archivo="$1"
    
    # Obtener el nombre del archivo sin la ruta
    nombre_archivo=$(basename "$archivo")
  
    nombre="${nombre_archivo%.*}"
    extension="${nombre_archivo##*.}"
    
    # Verificar si el nombre y la extensión exceden los límites
    if [ ${#nombre} -gt 8 ]; then
        log "ERROR" "The ${WHITE}$nombre_archivo${NORMAL} file name does not allow more than 8 characters."
        exit 1
    fi

    if [ ${#extension} -gt 3 ]; then
        log "ERROR" "The extension name does not allow more than 3 characters in the ${WHITE}$nombre_archivo${NORMAL} file"
        exit 1
    fi
}

##
## añade archivos ascii a la imagen dsk
##
##   Args:
##       DSK_IMAGE:  path y nombre de imagen
##       ASCII_FILE: path y nombre de fichero a añadir
##   Returns:
##       error: 0 ok <> Error
##

function add_file_to_disk_image {
   local DSK_IMAGE="$1"
   local ASCII_FILE="$2"
    image=$(basename "$DSK_IMAGE")
   if iDSK "$DSK_IMAGE" -i "$ASCII_FILE" -t 0 > /dev/null 2>&1; then
      log "OK" "${WHITE}$file${NORMAL} file added to ${WHITE}$image${NORMAL} disk image."
   else
      log "ERROR" "Error adding ${WHITE}$file${NORMAL}file to ${WHITE}$image${NORMAL} disk image"
   fi
}

##
## Elimina los comentarios "1 '" de los archivos bas
##
##   Args:
##       archivo_origen:  path del archivo origen
##       archivo_destino: path del archivo destino
##   Returns:
##       error: 0 ok <> Error
##

function delete_comments {
    local archivo_origen="$1"
    local archivo_destino="$2"
    if [[ "$(uname)" == "Darwin" ]]; then
        # macOS
        sed -E '/^1 '\''/d' "$archivo_origen" > "$archivo_destino"
    else
        # Linux u otros sistemas
        sed '/^1 '\''/d' "$archivo_origen" > "$archivo_destino"
    fi
    log "OK" "Deleted comments from the ${WHITE}$file${NORMAL} file."
}

##
## rellena con espacios un string
##
##   Args:
##       cadena: cadena string
##   Returns:
##       cadena rellena de espacios
##
function adjust_string() {
    local input="$1"
    file=$(basename "$input")
    local length=${#file}
    if [ $length -lt 12 ]; then
        printf "%-12s" "$file"
    else
        echo "${file:0:12}"
    fi
}

##
## muestra error generando imagen de disco en consola
##
##   Args:
##       fichero: Nombre de fichero
##       descripcion: Descripcion del resultado
##

function ERROR(){
  file=$(basename "$1")
  file=$(adjust_string $file)
  text="$2"
  echo -e "${WHITE}${BOLD}[${RED}${BOLD}  ERROR  ${WHITE}${BOLD}]${WHITE}${BOLD}[${BLUE}$file${WHITE}${BOLD}]${NORMAL}${RED} $text${NORMAL}"
}

##
## muestra OK generando imagen de disco en consola
##
##   Args:
##       fichero: Nombre de fichero
##       descripcion: Descripcion del resultado
##

function OK(){
  file=$(basename "$1")
  file=$(adjust_string $file)
  text="$2"
  echo -e "${WHITE}${BOLD}[${GREEN}${BOLD}   OK    ${WHITE}${BOLD}]${WHITE}${BOLD}[${BLUE}$file${WHITE}${BOLD}]${NORMAL} $text${NORMAL}"
}

##
## muestra WARNING generando imagen de disco en consola
##
##   Args:
##       fichero: Nombre de fichero
##       descripcion: Descripcion del resultado
##

function WARNING(){
  file=$(basename "$1")
  file=$(adjust_string $file)
  text="$2"
  echo -e "${WHITE}${BOLD}[${YELLOW}${BOLD} WARNING ${WHITE}${BOLD}]${WHITE}${BOLD}[${BLUE}$file${WHITE}${BOLD}]${NORMAL}${YELLOW}${BOLD} $text${NORMAL}"
}

##
## centra una cadena en otra
##
##   Args:
##       string: cadena de texto
##
##   Returns:
##       string cadena centrada en X espacios

function middle_tittle() {
    local cadena="$1"
    local longitud_cadena=${#cadena}
    local total_espacios=62

    if [ $longitud_cadena -ge $total_espacios ]; then
        echo "$cadena"
        return
    fi

    local espacios_izquierda=$(( (total_espacios - longitud_cadena) / 2 ))
    local espacios_derecha=$(( total_espacios - longitud_cadena - espacios_izquierda ))
    local cadena_centrada="$(printf '%*s' $espacios_izquierda '')$cadena$(printf '%*s' $espacios_derecha '')"
    echo "$cadena_centrada"
}

##
## compara versiones
##
##   Args:
##       string: version 1
##       string: version 2
##
##   Returns:
##       string cadena centrada en X espacios

function compare_versions() {
  if [ "$1" == "$2" ]; then
    return 0
  fi

  local IFS=.
  local i ver1=($1) ver2=($2)

  # Comparar cada parte de la versión
  for ((i=${#ver1[@]}; i<${#ver2[@]}; i++)); do
    ver1[i]=0
  done

  for ((i=0; i<${#ver1[@]}; i++)); do
    if [[ -z ${ver2[i]} ]]; then
      ver2[i]=0
    fi
    if ((10#${ver1[i]} > 10#${ver2[i]})); then
      return 1
    fi
    if ((10#${ver1[i]} < 10#${ver2[i]})); then
      return 2
    fi
  done

  return 0
}

##
## muestra en pantalla
##
##   Args:
##       level: nivel de log
##       file : nombre de fichero
##       text: descripcion
##
##   Returns:
##       muestra log en pantalla

function log(){
  level="$1"
  text="$2"
  # Ajustar la longitud de la segunda columna a 13 caracteres🚀
#   file=$(printf '%-12s' "$file")

  # Imprimir el mensaje formateado con el nivel y el archivo en los colores correspondientes
  if [ "$level" = "OK" ]; then
      echo "${GREEN}${BOLD}[+]${NORMAL} $text"
    #   printf "%-1s ${WHITE}${BOLD}=>${NORMAL} ${BLUE}${BOLD}%s${NORMAL} ${WHITE}${BOLD}=>${NORMAL} %s\n" "${GREEN}${BOLD}[+]${NORMAL}" "$file" "$text"
  elif [ "$level" = "WARNING" ]; then
      echo "${YELLOW}${BOLD}[!]${NORMAL} $text"
    #   printf "%-1s ${WHITE}${BOLD}=>${NORMAL} ${BLUE}${BOLD}%s${NORMAL} ${WHITE}${BOLD}=>${NORMAL} %s\n" "${YELLOW}${BOLD}[?]${NORMAL}" "$file" "$text"
  elif [ "$level" = "ERROR" ]; then
      echo "${RED}${BOLD}[-]${NORMAL} $text"
    #   printf "%-1s ${WHITE}${BOLD}=>${NORMAL} ${BLUE}${BOLD}%s${NORMAL} ${WHITE}${BOLD}=>${NORMAL} %s\n" "${RED}${BOLD}[-]${NORMAL}" "$file" "$text"
  elif [ "$level" = "INFO" ]; then
      echo "${BLUE}${BOLD}[*]${NORMAL} $text"
    #   printf "%-1s ${WHITE}${BOLD}=>${NORMAL} ${BLUE}${BOLD}%s${NORMAL} ${WHITE}${BOLD}=>${NORMAL} %s\n" "${BLUE}${BOLD}[*]${NORMAL}" "$file" "$text"
  else
    #   printf "%-7s ${BOLD}${WHITE}|${NORMAL} ${BLUE}${BOLD}%s${NORMAL} ${BOLD}${WHITE}|${NORMAL} %s\n" "⬜" "$file" "$text"
    echo "${BLUE}${BOLD}[*]${NORMAL} $text"
  fi
}

check_disc() {
    if [ -z "$1" ]; then
        echo -e "\nDrive A: disc missing"
        echo
        read -p "Retry, Ignore or Cancel? " choice
        
        case "$choice" in
            [Rr])
                check_disc
                ;;
            [Ii])
                check_disc
                ;;
            [Cc])
                echo -e "\nBad command"
                exit 1
                ;;
            *)
                check_disc
                ;;
        esac
    fi
}