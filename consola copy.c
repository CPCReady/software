#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

// Lista de comandos permitidos
char *comandos_permitidos[] = {"ls", "pwd", "cd", "date", "whoami"};

// Verificar si un comando está en la lista de comandos permitidos
int es_comando_permitido(char *comando) {
    int i;
    for (i = 0; i < sizeof(comandos_permitidos) / sizeof(char *); i++) {
        if (strcmp(comandos_permitidos[i], comando) == 0) {
            return 1;
        }
    }
    return 0;
}

void print_toolbar() {
    // Imprimir la barra de herramientas
    char* home = getenv("HOME");
    printf("HOME: %s\n", home);
}

int main() {
    char comando[100];
    char parametros[100];
    char input[200];

    while (1) {
        // Limpiar la pantalla
        printf("\033[H\033[J");

        print_toolbar();

        // Mostrar el prompt
        printf("Ready ");
        fgets(input, 200, stdin);

        // Separar el comando y los parámetros
        sscanf(input, "%s %[^\n]", comando, parametros);

        // Verificar si el comando es 'exit', salir del bucle
        if (strcmp(comando, "exit") == 0) {
            printf("Saliendo del programa...\n");
            break;
        }

        // Verificar si el comando es permitido
        if (es_comando_permitido(comando)) {
            // Ejecutar el comando y mostrar el resultado
            char cmd[300];
            sprintf(cmd, "%s %s", comando, parametros);
            system(cmd);
        } else {
            printf("Syntax Error\n");
        }
    }

    return 0;
}