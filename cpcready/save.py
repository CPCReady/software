
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
import subprocess

def create_disk_image(name):
    """Crea una imagen de disco CPC.

    Args:
        name (str): nombre de la imagen de disco.
    """
    ## Comando para crear la imagen de disco
    COMMAND = var.IDSK_TOOL + f" {name} -n "
    proceso = subprocess.run(COMMAND, shell=True, capture_output=True, text=True)

    # Verificar la salida y posibles errores
    if not proceso.returncode == 0:
        function.message_error(f"\nError creating disk image {name}.\n", "bold")
        function.message_error(f"{proceso.stderr}")
        exit(1)

def add_file_ascii_disk_image(image, file):
    """Añade fichero ASCII a la imagen de disco.

    Args:
        image (str): nombre de la imagen de disco.
        file (str): nombre del fichero a añadir.
    """
    ## Comando para crear la imagen de disco
    COMMAND = var.IDSK_TOOL + f" {image} -n "
    proceso = subprocess.run(COMMAND, shell=True, capture_output=True, text=True)

    # Verificar la salida y posibles errores
    if not proceso.returncode == 0:
        function.message_error(f"\nError creating disk image {image}.\n", "bold")
        function.message_error(f"{proceso.stderr}")
        exit(1)