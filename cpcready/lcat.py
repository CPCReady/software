
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

from cpcready import variables as var
from cpcready import common as function
from prompt_toolkit import print_formatted_text
from prompt_toolkit.formatted_text import HTML
import subprocess
import os
import math

def cat_image_disc(name):
    """Muestra el contenido de una imagen de disco.

    Args:
        name (str): nombre de la imagen de disco.
    """
    ## Comando para crear la imagen de disco
    COMMAND = var.IDSK_TOOL + f" {name} -l "
    proceso = subprocess.run(COMMAND, shell=True, capture_output=True, text=True)

    # Verificar la salida y posibles errores
    if not proceso.returncode == 0:
        function.message_error(f"\nError creating disk image {name}.\n", "bold")
        function.message_error(f"{proceso.stderr}")
        exit(1)

def count_total_kilobytes_in_folder(folder_path):
    """Cuenta el total de kilobytes de todos los archivos en una carpeta.

    Args:
        folder_path (str): Ruta de la carpeta.

    Returns:
        int: Total de kilobytes de todos los archivos en la carpeta, redondeado al alza.
    """
    total_bytes = 0
    for root, dirs, files in os.walk(folder_path):
        for file in files:
            file_path = os.path.join(root, file)
            total_bytes += os.path.getsize(file_path)
    return math.ceil(total_bytes / 1024) 


def show_files_in_image_disc():
    print("Files in image disc:")
    image = function.replace_spaces_with_underscore(function.get_value_cpcready("disc"))
    DISC_IMAGE = var.PWD + var.OUT_FOLDER + image
    cat_image_disc(DISC_IMAGE)
    total_bytes = count_total_kilobytes_in_folder(var.FILES_FOLDER)
    print(f"Total bytes: {total_bytes}")
    print_formatted_text(HTML(f"<ansigreen>See</ansigreen><ansiblue> https://github.com/CPCReady/software</ansiblue><ansigreen> for more information.</ansigreen>"))