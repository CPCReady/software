
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
from cpcready import version
import platform
import os
import getpass
import yaml
from ruamel.yaml import YAML
from datetime import datetime
from prompt_toolkit import prompt
from prompt_toolkit.formatted_text import HTML
from prompt_toolkit import print_formatted_text
from jinja2 import Template
from jinja2 import Environment, FileSystemLoader

def get_os_type():
    """Obtener el tipo de sistema operativo.

    Returns:
        _type_: system type
    """
    os_type = platform.system()
    if os_type == "Linux":
        return "linux"
    elif os_type == "Darwin":
        return "osx"
    elif os_type == "Windows":
        return "windows"
    else:
        message_error(f"Unsupported OS: {os_type}")
        exit(1)
        
def get_filename_from_path(file_path):
    """Devuelve el nombre de fichero.

    Args:
        file_path (str): path del fichero.
    """
    return os.path.basename(file_path)

def message_compilation(text, result):
    """Mostrar mensaje de compilacion.

    Args:
        text (str): Texto del mensaje.
    """
    if result == "OK":
        print_formatted_text(HTML(f"<ansiwhite>[</ansiwhite><ansigreen><bold>  OK  </bold></ansigreen><ansiwhite>] {text}</ansiwhite>"))
    elif result == "WARNING":
        print_formatted_text(HTML(f"<ansiwhite>[</ansiwhite><ansiyellow><bold>WARNING</bold></ansiyellow><ansiwhite>] {text}</ansiwhite>"))
    elif result == "ERROR":
        print_formatted_text(HTML(f"<ansiwhite>[</ansiwhite><ansired><bold> ERROR </bold></ansired><ansiwhite>] {text}</ansiwhite>"))

def message_error(text, format="normal"):
    """Mostrar mensaje de error.

    Args:
        text (str): Texto del mensaje.
    """
    if format == "normal":
        print_formatted_text(HTML(f"<ansired>{text}</ansired>"))
    elif format == "bold":
        print_formatted_text(HTML(f"<ansired><b>{text}</b></ansired>"))
    else:
        print_formatted_text(HTML(f"<ansired>{text}</ansired>"))

def message_info(text, format="normal"):
    """Mostrar mensaje de informacion.

    Args:
        text (str): Texto del mensaje.
    """
    if format == "normal":
        print_formatted_text(HTML(f"<ansiblue>{text}</ansiblue>"))
    elif format == "bold":
        print_formatted_text(HTML(f"<ansiblue><b>{text}</b></ansiblue>"))
    else:
        print_formatted_text(HTML(f"<ansiblue>{text}</ansiblue>"))

def message_ok(text, format="normal"):
    """Mostrar mensaje de informacion.

    Args:
        text (str): Texto del mensaje.
    """
    if format == "normal":
        print_formatted_text(HTML(f"<ansigreen>{text}</ansigreen>"))
    elif format == "bold":
        print_formatted_text(HTML(f"<ansigreen><b>{text}</b></ansigreen>"))
    else:
        print_formatted_text(HTML(f"<ansigreen>{text}</ansigreen>"))

def message_ok(text, format="normal"):
    """Mostrar mensaje de warning.

    Args:
        text (str): Texto del mensaje.
    """
    if format == "normal":
        print_formatted_text(HTML(f"<ansigreen>{text}</ansigreen>"))
    elif format == "bold":
        print_formatted_text(HTML(f"<ansigreen><b>{text}</b></ansigreen>"))
    else:
        print_formatted_text(HTML(f"<ansigreen>{text}</ansigreen>"))

def message_normal(text, format="normal"):
    """Mostrar mensaje de warning.

    Args:
        text (str): Texto del mensaje.
    """
    if format == "normal":
        print_formatted_text(HTML(f"{text}"))
    elif format == "bold":
        print_formatted_text(HTML(f"<b>{text}</b>"))
    else:
        print_formatted_text(HTML(f"{text}"))

def create_folder(path):
    """Crea carpeta en la ruta especificada.

    Args:
        path (_type_): path donde se creara la carpeta.
    """
    try:
        os.makedirs(path)
        return True
    except FileExistsError:
        return False
    
import os

def check_folder_exists(path):
    """Comprueba si existe una carpeta en la ruta especificada.

    Args:
        path (str): Ruta de la carpeta a comprobar.

    Returns:
        bool: True si la carpeta existe, False en caso contrario.
    """
    return os.path.isdir(path)


def create_template(template, output, data):
    """Crea un archivo a partir de una plantilla.

    Args:
        template (str): Nombre de la plantilla.
        output (str): Nombre del archivo de salida.
        data (dict): Diccionario con los datos a reemplazar en la plantilla.
    """
    environment = Environment(loader=FileSystemLoader(var.TEMPLATE_PATH))
    template = environment.get_template(template)
    with open(output, "w") as file:
        file.write(template.render(data))

def replace_spaces_with_underscore(text):
    """Reemplaza los espacios en blanco en una cadena de texto por guiones bajos.

    Args:
        text (str): Cadena de texto a modificar.

    Returns:
        str: Cadena de texto con los espacios en blanco reemplazados por guiones bajos.
    """
    return text.replace(' ', '_')

def get_current_username():
    """Obtiene el nombre de usuario actual.

    Returns:
        str: Nombre de usuario actual.
    """
    return getpass.getuser()

def get_current_datetime():
    """Obtiene la fecha y hora actuales.

    Returns:
        str: Fecha y hora actuales en formato 'YYYY-MM-DD HH:MM:SS'.
    """
    return datetime.now().strftime('%Y-%m-%d %H:%M:%S')

def get_value_cpcready(key):
    """Lee un archivo YAML y devuelve el valor asociado a una clave.

    Args:
        file_path (str): Ruta del archivo YAML.
        key (str): Clave cuyo valor se quiere obtener.

    Returns:
        El valor asociado a la clave en el archivo YAML, o None si la clave no existe.
    """
    with open(var.PWD + var.CPCREADY_FILE, 'r') as file:
        data = yaml.safe_load(file)
        return data.get(key)

def update_value_cpcready(key, value):
    """Modifica un valor en un archivo YAML o agrega una nueva clave si no existe.

    Args:
        file_path (str): Ruta del archivo YAML.
        key (str): Clave cuyo valor se quiere modificar.
        value: Nuevo valor para la clave.
    """
    yaml = YAML()
    with open(var.PWD + var.CPCREADY_FILE, 'r') as file:
        data = yaml.load(file)

    data[key] = value

    with open(var.PWD + var.CPCREADY_FILE, 'w') as file:
        yaml.dump(data, file)
    

def check_file_exists(filename):
    """Comprueba si existe un archivo en la ruta actual.

    Args:
        filename (str): Nombre del archivo a comprobar.

    Returns:
        bool: True si el archivo existe, False en caso contrario.
    """
    return os.path.isfile(filename)

def is_cpcready_project():
    """Comprueba si el directorio actual es un proyecto de CPCReady.

    Returns:
        bool: True si el directorio actual es un proyecto de CPCReady, False en caso contrario.
    """
    if not check_file_exists(var.CPCREADY_FILE):
        message_error(f"\nThis software can only be used in a CPCReady project.")
        exit(1)