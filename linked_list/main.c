#include <stdio.h>
#include <stdlib.h>

struct Node {
    int value;
    struct Node *next;
} typedef Node;

// Write a function that appends a node to a linked list
Node* append(Node **head, int value) {
    // TODO: Implement
    return NULL;
}

// Write a function that prepends a node to a linked list
Node* prepend(Node **head, int value) {
    // TODO: Implement
    return NULL;
}

void print_list(Node *head) {
    Node *curr = head;
    while (curr) {
        printf("%d ", curr->value);
        curr = curr->next;
    }
    printf("\n");
}

int main() {
    Node *head = NULL;
    int action, val;
    while (scanf("%d %d", &action, &val) == 2) {
        if (action == 0) prepend(&head, val);
        else append(&head, val);
        print_list(head);
    }
    return 0;
}
