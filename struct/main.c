#include <stdio.h>
#include <stdlib.h>

typedef struct {
    int x;
    int y;
} Cartesian;

Cartesian* add(Cartesian *a, Cartesian *b) {
    // TODO: Implement
    return NULL;
}

Cartesian create(int x, int y) {
    // TODO: Implement
    Cartesian c = {x, y};
    return c;
}

int main() {
    int x1, y1, x2, y2;
    if (scanf("%d %d %d %d", &x1, &y1, &x2, &y2) == 4) {
        Cartesian a = create(x1, y1);
        Cartesian b = create(x2, y2);
        Cartesian *sum = add(&a, &b);
        if (sum) {
            printf("%d %d\n", sum->x, sum->y);
            free(sum);
        }
    }
    return 0;
}
