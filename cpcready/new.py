
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
from prompt_toolkit.formatted_text import HTML
from prompt_toolkit import print_formatted_text

def create_project(project):
    ## Si el nombre de proyecto tiene espacios reemplazamos por "_".
    project = function.replace_spaces_with_underscore(project)
    ## Creamos carpetas del proyecto. Si existen salimos con error.
    if function.check_folder_exists(var.PWD + project):
        function.message_error(f"\nProject {project} already exists.", "bold")
        exit(1)

    function.create_folder(var.PWD + project)
    function.create_folder(var.PWD + project + "/" + var.SRC_FOLDER)
    function.create_folder(var.PWD + project + "/" + var.OUT_FOLDER)
    function.create_folder(var.PWD + project + "/" + var.TMP_FOLDER)
    function.create_folder(var.PWD + project + "/" + var.VSC_FOLDER)
    function.create_folder(var.PWD + project + "/" + var.FILES_FOLDER)
    
    ## Creamos el archivo de configuración del proyecto y demas templates.
    config = {'project': project}
    function.create_template("CPCReady.j2", var.PWD + project + "/CPCReady", config)
    config = {'project': project, 'current_username': function.get_current_username(), 'current_datetime': function.get_current_datetime(), 'version': var.version}
    function.create_template("DISC.j2", var.PWD + project + f"/{var.SRC_FOLDER}/DISC.BAS", config)
    config = {'SYSTEM': var.HOST_SYSTEM}
    function.create_template("settings.j2", var.PWD + project + f"/{var.VSC_FOLDER}/settings.json", config)
    DISC_IMAGE = var.PWD + project + "/" + var.OUT_FOLDER + project + ".dsk"
    idsk.create_disk_image(DISC_IMAGE)
    ## mostramos informacion al usuario.
    print_formatted_text(HTML(f"<ansiwhite><b>\nCreated project</b></ansiwhite><ansigreen><b> {project} </b></ansigreen><ansiwhite><b>in</b></ansiwhite><ansigreen><b> {var.PWD} </b></ansigreen>"))