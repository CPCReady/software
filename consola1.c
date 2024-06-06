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
    // Guardar la posición del cursor
    printf("\033[s");

    // Mover el cursor a la primera línea
    printf("\033[1;1H");

    // Imprimir la barra de herramientas
    printf("Esta es la barra de herramientas\n");

    // Restaurar la posición del cursor
    printf("\033[u");
}

int main() {
    system("clear");
    char comando[100];
    char parametros[100];
    char input[200];

    // Variable para controlar si es la primera vez que se ejecuta el programa
    int primera_vez = 1;

    while (1) {
        print_toolbar();

        // Si es la primera vez que se ejecuta el programa, agregar una nueva línea
        if (primera_vez) {
            printf("\n");
            primera_vez = 0;
        }

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