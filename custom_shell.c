#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

// Variable global para almacenar el valor de HOME
char home[100];

// Lista de comandos permitidos
const char *comandos_permitidos[] = {"ls", "pwd", "cd", "date", "whoami", "exit"};

// Función para verificar si el comando es permitido
int es_comando_permitido(const char *comando) {
    for (int i = 0; i < sizeof(comandos_permitidos) / sizeof(comandos_permitidos[0]); ++i) {
        if (strcmp(comando, comandos_permitidos[i]) == 0) {
            return 1;
        }
    }
    return 0;
}

// Función para mostrar la cabecera
void mostrar_cabecera() {
    // Limpiar la pantalla
    system("clear");

    // Imprimir el valor de HOME
    printf("=== HOME: %s ===\n", home);
}

// Función principal
int main() {
    // Obtener el valor de HOME al inicio
    char *home_env = getenv("HOME");
    if (home_env != NULL) {
        strncpy(home, home_env, sizeof(home) - 1);
        home[sizeof(home) - 1] = '\0';
    } else {
        strcpy(home, "HOME no definido");
    }

    // Imprimir la cabecera al inicio
    mostrar_cabecera();

    // Bucle infinito para leer comandos
    while (1) {
        // Mostrar el prompt
        printf("Ready ");

        // Leer el comando del usuario
        char comando[100];
        fgets(comando, sizeof(comando), stdin);

        // Eliminar el salto de línea del final
        comando[strcspn(comando, "\n")] = '\0';

        // Verificar si el comando es 'exit', salir del bucle
        if (strcmp(comando, "exit") == 0) {
            printf("Saliendo del programa...\n");
            break;
        }

        // Verificar si el comando es 'cd' para actualizar el valor de HOME si es necesario
        if (strcmp(comando, "cd") == 0) {
            char *new_home = getenv("HOME");
            if (new_home != NULL) {
                strncpy(home, new_home, sizeof(home) - 1);
                home[sizeof(home) - 1] = '\0';
            }
        }

        // Limpiar la pantalla antes de ejecutar el comando
        system("clear");

        // Imprimir la cabecera antes de ejecutar el comando
        mostrar_cabecera();

        // Verificar si el comando es permitido
        if (es_comando_permitido(comando)) {
            // Ejecutar el comando
            system(comando);
        } else {
            printf("Comando no permitido.\n");
        }
    }

    return 0;
}
