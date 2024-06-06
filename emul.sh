#!/bin/bash

# Función para pedir y verificar la ruta
ask_for_path() {
    read -p "Introduce la ruta: " ruta
    if [ -d "$ruta" ]; then
        echo "La ruta es válida."
        return 0
    else
        echo "La ruta no existe. Por favor, introduce una ruta válida."
        return 1
    fi
}

# Pedir la ruta hasta que sea válida
while ! ask_for_path; do
    :
done

# Grabar la ruta en el archivo YAML
ruta="$ruta"  # Ruta introducida por el usuario
yaml_file="$HOME/cpcready/CPCReady.yaml"

# Crear el directorio cpcready si no existe
mkdir -p "$(dirname "$yaml_file")"

# Escribir en el archivo YAML
echo "ruta: \"$ruta\"" > "$yaml_file"

echo "La ruta se ha guardado en $yaml_file"
