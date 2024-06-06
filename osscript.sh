#!/bin/bash

# Función para seleccionar un archivo y guardar su ruta y nombre
select_and_save_file() {
    local selected_file
    selected_file=$(osascript -e 'tell app "System Events" to POSIX path of (choose file)')

    # Verificar si se seleccionó un archivo
    if [ -n "$selected_file" ]; then
        echo "Ruta seleccionada: $selected_file"
        # Guardar la ruta del archivo seleccionado en otro archivo
        echo "$selected_file" > ruta_seleccionada.txt
        echo "Ruta guardada en ruta_seleccionada.txt"
    else
        echo "No se seleccionó ningún archivo."
    fi
}

# Llamar a la función para seleccionar y guardar el archivo
select_and_save_file
