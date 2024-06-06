#!/bin/bash

# Lista de comandos permitidos
comandos_permitidos=("ls" "pwd" "cd" "date" "whoami")

# Verificar si un comando está en la lista de comandos permitidos
function es_comando_permitido {
    local comando=$1
    for i in "${comandos_permitidos[@]}"; do
        if [[ "$i" == "$comando" ]]; then
            return 0
        fi
    done
    return 1
}

# Función principal
function main {
    local comando
    local parametros
    local input
    local output

    while true; do
        # Imprimir el directorio home
        tput cup 0 0
        echo "Home: $HOME"
        
        # Mostrar el prompt
        tput cup 1 0
        read -p "Ready " input
        
        # Separar el comando y los parámetros
        comando=$(echo $input | awk '{print $1}')
        parametros=$(echo $input | awk '{for (i=2; i<=NF; i++) printf $i " "; if (NF>1) print ""}')
        
        # Verificar si el comando es 'exit', salir del bucle
        if [[ "$comando" == "exit" ]]; then
            echo "Saliendo del programa..."
            break
        fi
        
        # Verificar si el comando es permitido
        if es_comando_permitido $comando; then
            # Ejecutar el comando y capturar la salida
            output=$($comando $parametros)
            
            # Limpiar la pantalla y volver a imprimir el directorio home
            clear
            tput cup 0 0
            echo "Home: $HOME"
            
            # Imprimir la salida del comando
            echo "$output"
        else
            echo "Syntax Error"
        fi
    done
}

# Ejecutar la función principal
main