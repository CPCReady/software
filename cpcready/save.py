
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
from cpcready import save as idsk
import subprocess
import shutil
import os
from prompt_toolkit import print_formatted_text
from prompt_toolkit.formatted_text import HTML


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
        function.message_error(f"\nError creating disk image {function.get_filename_from_path(name)}.\n", "bold")
        function.message_error(f"{proceso.stderr}")
        exit(1)

def add_file_ascii_disk_image(image, file):
    """Añade fichero ASCII a la imagen de disco.

    Args:
        image (str): nombre de la imagen de disco.
        file (str): nombre del fichero a añadir.
    """
    try:
        ## Comando para crear la imagen de disco
        COMMAND = var.IDSK_TOOL + f" {image} -i {file} -t 0 > /dev/null 2>&1"
        proceso = subprocess.run(COMMAND, shell=True)
        if not proceso.returncode == 0:
            function.message_error(f"\nError creating disk image {function.get_filename_from_path(image)}.\n", "bold")
            function.message_error(f"{proceso.stderr}")
            exit(1)
        function.message_compilation(f"Add {function.get_filename_from_path(file)} to {function.get_filename_from_path(image)}","OK")
    except Exception as e:
        function.message_compilation(f"{e}","ERROR")
        exit(1)    
        
def convert_file_to_dos(file,destination):
    """Convierte un fichero en formato UNIX a DOS.

    Args:
        source (str): origen del fichero.
        destination (str): destino del fichero.
    """
    # with open(file, 'r') as file:
    #     content = file.read()
    # dos_content = content.replace('\n', '\r\n')
    # with open(destination, 'w') as file:
    #     file.write(dos_content)
    
    

    # try:
    #     shutil.copy(file, destination)
    # except Exception as e:
    #     function.message_error(f"Error al copiar el archivo: {e}")
    #     exit(1)
    try:
        COMMAND = f"unix2dos {destination}"
        proceso = subprocess.run(COMMAND, shell=True, capture_output=True, text=True)
        if not proceso.returncode == 0:
            function.message_error(f"\nError convert file {file} to DOS.\n", "bold")
            function.message_error(f"{proceso.stderr}")
            exit(1)
        function.message_compilation(f"Convert {function.get_filename_from_path(destination)} to DOS","OK")
    except Exception as e:
        function.message_compilation(f"{e}","ERROR")
        exit(1)    
    
def remove_comments_from_bas_files(input_file, output_file):
    """Elimina las lineas del fichero que sean comentarios.

    Args:
        input_file (str): origen del fichero.
        output_file (str): destino del fichero.
    """
    try:
        with open(input_file, 'r') as f_input:
            lines = f_input.readlines()

        # Filtrar las líneas que no comienzan con "1'"
        filtered_lines = [line for line in lines if not line.startswith("1 '")]

        with open(output_file, 'w') as f_output:
            for line in filtered_lines:
                f_output.write(line)
        function.message_compilation(f"Remove comments to {function.get_filename_from_path(output_file)}","OK")
    except Exception as e:
        function.message_compilation(f"{e}","ERROR")
        exit(1)    

def create_image_disc_from_files(file):
    """Crea una imagen de disco CPC con los ficheros del proyecto.

    Args:
        file (str): nombre del archivo.
    """ 
    PROJECT = function.get_value_cpcready("name").upper()
    print_formatted_text(HTML(f"\n<ansigreen><bold>** </bold></ansigreen><ansiblue>{PROJECT}</ansiblue><ansigreen><bold> ** </bold></ansigreen>"))
    print_formatted_text(HTML(f"<ansiwhite>--------------------------------------------------------</ansiwhite>"))    
    image = function.replace_spaces_with_underscore(function.get_value_cpcready("disc"))
    DISC_IMAGE = var.PWD + var.OUT_FOLDER + image
    idsk.create_disk_image(DISC_IMAGE)
    function.message_compilation(f"Create disc image {image}","OK")
    print_formatted_text(HTML(f"<ansiwhite>--------------------------------------------------------</ansiwhite>"))  
    if file == None:
        for root, dirs, files in os.walk(var.SRC_FOLDER):
            for file in files:
                remove_comments_from_bas_files(var.SRC_FOLDER + "/" + file, var.FILES_FOLDER + "/" + file)
                convert_file_to_dos(var.SRC_FOLDER + "/" + file, var.FILES_FOLDER + "/" + file)
                add_file_ascii_disk_image(var.OUT_FOLDER + image, var.FILES_FOLDER + "/" + file)
                print_formatted_text(HTML(f"<ansiwhite>--------------------------------------------------------</ansiwhite>"))  
    else:
        remove_comments_from_bas_files(var.SRC_FOLDER + "/" + file, var.FILES_FOLDER + "/" + file)
        convert_file_to_dos(var.SRC_FOLDER + "/" + file, var.FILES_FOLDER + "/" + file)
        add_file_ascii_disk_image(var.OUT_FOLDER + image, var.FILES_FOLDER + "/" + file)
    print_formatted_text(HTML(f"<ansigreen>Successfully generated disk image</ansigreen>"))
    print_formatted_text(HTML(f"<ansiwhite>--------------------------------------------------------</ansiwhite>"))