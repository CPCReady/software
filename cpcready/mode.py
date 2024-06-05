
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

def is_in_screen_mode(value):
    """Comprueba si un valor está en la lista SCREEN_MODE.

    Args:
        value (str): Valor a comprobar.

    Returns:
        bool: True si el valor está en la lista, False en caso contrario.
    """
    return value in var.SCREEN_MODE

def change_screen_mode(mode):
    """Cambia el modo de imagen del proyecto.

    Args:
        mode (str): modo de imagen
    """
    if mode == None:
        function.message_normal("\nCurrent screen mode is: " + function.get_value_cpcready("mode"))
        exit(0)
    else:
        if is_in_screen_mode(mode) == False:
            function.message_error("\nSyntax Error\nInvalid screen mode.")
            exit(1)
        function.update_value_cpcready("mode", mode)
        function.message_ok("\nChanged Screen mode: " + mode)