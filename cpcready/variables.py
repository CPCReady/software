
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
##  execute clear command

from cpcready import version
from cpcready import common as function
import os


HOST_SYSTEM   = function.get_os_type()
PWD           = os.getcwd() + "/"
DIR_PATH      = os.path.dirname(os.path.realpath(__file__))
TEMPLATE_PATH = os.path.join(DIR_PATH, 'templates/')
VSC_FOLDER    = ".vscode/"
SRC_FOLDER    = "src/"
OUT_FOLDER    = "out/"
FILES_FOLDER  = f"{OUT_FOLDER}/files"
TMP_FOLDER    = "tmp/"
CPC_MODELS    = ["464", "664", "6128"]
SCREEN_MODE   = ["0", "1", "2"]
IDSK_TOOL     = os.path.join(DIR_PATH, 'resources/' + HOST_SYSTEM + '/iDSK')
CPCREADY_FILE = "CPCReady"