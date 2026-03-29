#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>

int process(int *fd, char *string) {
    // TODO: Implement
    return 0;
}

int main() {
    char buf[1024];
    if (fgets(buf, sizeof(buf), stdin)) {
        buf[strcspn(buf, "\n")] = 0;
        int fd;
        process(&fd, buf);
        char out[1024];
        int n = read(fd, out, sizeof(out)-1);
        if (n > 0) {
            out[n] = 0;
            printf("%s\n", out);
        }
        close(fd);
        wait(NULL);
    }
    return 0;
}
