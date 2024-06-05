
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
from cpcready import version
from cpcready import new as command_new
from cpcready import amsdos as command_amsdos
from cpcready import disc as command_disc
from cpcready import lcat as command_lcat
from cpcready import mode as command_mode
from cpcready import model as command_model
from cpcready import run as command_run
from cpcready import save as command_save
from prompt_toolkit import print_formatted_text
from prompt_toolkit.formatted_text import HTML
import click


@click.group()
def main():
    """ CPCReady: A tool to prepare your CPC project from Visual Studio Code."""
    pass

@click.command()
def about():
    """About CPCReady"""
    function.message_info(f"\nCPCReady - A tool to prepare your CPC project from Visual Studio Code.\n")
    function.message_info(f"Version: {var.version}")
    function.message_info(f"CPCReady-Core Version: {var.version}\n")
    print_formatted_text(HTML(f"<ansigreen>See</ansigreen><ansiblue> https://github.com/CPCReady/software</ansiblue><ansigreen> for more information.</ansigreen>"))
main.add_command(about)


@click.command()
@click.argument('file', required=False)
def save(file):
    """Generates disk image with the project files. If no FILE is provided, it will generate a entire project disk image."""
    function.is_cpcready_project()
    if file:
        click.echo(f'Param: {file}')
    else:
        click.echo('No param provided.')
main.add_command(save)


@click.command()
@click.argument('file', required=False)
def run(file):
    """Run the file passed as a parameter in the emulator. If File is not specified, DISC.BAS is taken by default."""
    function.is_cpcready_project()
    if file:
        click.echo(f'Param: {file}')
    else:
        click.echo('No param provided.')
main.add_command(run)

@click.command()
def lcat():
    """Displays the contents of the disk image."""
    function.is_cpcready_project()
    click.echo('No param provided.')
main.add_command(lcat)

@click.command()
@click.argument('project', required=True)
def new(project):
    """Create a CPCReady project."""
    command_new.create_project(project)
main.add_command(new)

@click.command()
@click.argument('cpc', required=False)
def model(cpc):
    """Change the project's CPC model. If no parameter is passed, it shows the current CPC model of the project."""
    function.is_cpcready_project()
    command_model.change_cpc_model(cpc) 
main.add_command(model)

@click.command()
@click.argument('screen', required=False)
def mode(screen):
    """Change the project's Screen mode. If no parameter is passed, it shows the current screen mode of the project."""
    function.is_cpcready_project()
    command_mode.change_screen_mode(screen)
main.add_command(mode)

@click.command()
@click.argument('image', required=False)
def disc(image):
    """Create disk image for the project. If no parameter is passed, displays the current disk image of the project."""
    function.is_cpcready_project()
    command_disc.change_disc_image(image)
main.add_command(disc)

@click.command()
@click.argument('workspace', required=True)
def amsdos(workspace):
    """CPC style work terminal for visual studio code."""
    function.is_cpcready_project()
    if workspace:
        click.echo(f'Param: {workspace}')
    else:
        click.echo('No param provided.')
main.add_command(amsdos)

if __name__ == '__main__':
    main()