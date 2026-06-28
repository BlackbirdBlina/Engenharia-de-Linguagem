#include "linked_list.h"
#include <stdlib.h>

NodeInfo* CreateNodeInfo(char* content) {
    NodeInfo* node = malloc(sizeof(NodeInfo));
    if (node) {
        node->content = content;
        node->next = NULL;
    }
    return node;
}

LinkedList* CreateLinkedList() {
    LinkedList* list = (LinkedList*)malloc(sizeof(LinkedList));
    if (list) {
        list->start = NULL;
        list->end = NULL;
        list->size = 0;
    }
    return list;
}

void PushElement(LinkedList* list, NodeInfo* node) {
    if (!list || !node) {
        return;
    }

    if (!list->start) {
        list->start = node;
        list->end = node;
    } else {
        list->end->next = node;
        list->end = node;
    }
    list->size++;
}
NodeInfo* AccessAt(LinkedList* list, int index) {
    if (!list) {
        return NULL;
    }
    if (index < 0 || index >= list->size) {
        return NULL;
    }
    NodeInfo* aux = list->start;
    for (int i = 0; i < index; i++) {
        aux = aux->next;
        if (!aux) {
            break;
        }
    }
    return aux;
}
