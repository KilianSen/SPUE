#include <stdio.h>

int isPrime(int n) {
    // TODO: Implement
    return 0;
}

int main() {
    int n;
    while (scanf("%d", &n) == 1) {
        if (isPrime(n)) printf("%d is prime\n", n);
        else printf("%d is not prime\n", n);
    }
    return 0;
}
