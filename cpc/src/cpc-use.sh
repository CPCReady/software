# src/cpc-use.sh
cpc_use() {
    local name="$1"
    if [ -z "$name" ]; then
        echo "Error: No se ha proporcionado un parámetro."
        echo "Uso: cpc use <nombre>"
        return 1
    fi
    
    echo "Ejecutando comando 'use' con el parámetro: $name"
    # Aquí puedes agregar la lógica adicional para manejar el comando 'use'
}