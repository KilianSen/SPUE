#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    if (argc < 2) return 0;
    int count = atoi(argv[1]);
    for (int i = 0; i < count && (i + 2) < argc; i++) {
        printf("%s%s", argv[i+2], (i + 1 < count && i + 3 < argc) ? " " : "");
    }
    printf("\n");
    return 0;
}
