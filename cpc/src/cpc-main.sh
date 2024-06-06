# src/cpc-main.sh
cpc() {
    case "$1" in
        use)
            shift
            source "$CPC_DIR/src/cpc-use.sh"
            cpc_use "$@"
            ;;
        help)
            source "$CPC_DIR/src/cpc-help.sh"
            cpc_help
            ;;
        *)
            echo "Comando desconocido: $1"
            cpc help
            ;;
    esac
}
