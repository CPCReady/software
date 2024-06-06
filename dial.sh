#!/bin/bash

# Función para mostrar el cuadro de diálogo de selección de archivo y guardar la ruta seleccionada
select_file() {
    local result
    result=$(dialog --title "Seleccionar Archivo" --fselect $HOME/ 14 70 3>&1 1>&2 2>&3) 
    # Revertir redirección para capturar la salida de dialog correctamente
    echo "$result"
}

# Mostrar el cuadro de diálogo y obtener la ruta del archivo seleccionado
selected_file=$(select_file)

# Verificar si se seleccionó un archivo
if [ -n "$selected_file" ]; then
    echo "Ruta seleccionada: $selected_file"
    # Guardar la ruta del archivo seleccionado en otro archivo
    echo "$selected_file" > ruta_seleccionada.txt
    echo "Ruta guardada en ruta_seleccionada.txt"
else
    echo "No se seleccionó ningún archivo."
fi
