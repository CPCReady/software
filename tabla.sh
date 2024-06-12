#!/bin/bash

# Función para pintar una tabla con columnas de ancho fijo
function pintar_tabla {
    local -n rows=$1

    # Pintar la cabecera
    printf "| %-20s | %-20s | %s\n" "Columna 1" "Columna 2" "Columna 3"

    # Pintar separador
    printf "|---------------------|---------------------|---------------------|\n"

    # Pintar filas
    for row in "${rows[@]}"; do
        IFS='|' read -r -a cols <<< "$row"
        printf "[ %-20s ][ %-20s ] => %s\n" "${cols[0]}" "${cols[1]}" "${cols[2]}"
    done
}

# Ejemplo de uso
rows=(
    "Valor1|Valor2|Valor3"
    "LargoValor1|LargoValor2|ValorLargo3"
    "Corto|Medio|Texto largo para la columna 3"
)

pintar_tabla rows
