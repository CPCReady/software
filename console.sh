#!/bin/bash

# Lista de comandos permitidos
comandos_permitidos=("ls" "pwd" "cd" "date" "whoami")

# Verificar si un comando está en la lista de comandos permitidos
es_comando_permitido() {
    for comando_permitido in "${comandos_permitidos[@]}"; do
        if [[ $1 == $comando_permitido ]]; then
            return 0
        fi
    done
    return 1
}

# Imprimir la barra de herramientas
print_toolbar() {
    # Guardar la posición del cursor
    echo -en "\e[s"

    # Mover el cursor a la última línea
    echo -en "\e[$(tput lines);1H"

    # Cambiar el color de fondo a azul y el color de texto a blanco
    echo -e "\e[44;37mEsta es la barra de herramientas\e[0m"

    # Restaurar la posición del cursor
    echo -en "\e[u"
}

while true; do
    # Mostrar el prompt
    echo -n "Ready "
    read -r comando parametros

    # Verificar si el comando es 'exit', salir del bucle
    if [[ $comando == "exit" ]]; then
        echo "Saliendo del programa..."
        break
    fi

    # Verificar si el comando es permitido
    if es_comando_permitido "$comando"; then
        # Ejecutar el comando y mostrar el resultado
        $comando $parametros
    else
        echo "Syntax Error"
    fi

    # Imprimir la barra de herramientas después de cada comando
    print_toolbar
done