#ifndef HASHTABLE
#define HASHTABLE
#define HASHTABLE_SIZE 16
#include "hash_table.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <assert.h>

typedef struct ht_entry ht_entry;
struct ht_entry {
    const char * key;
    void * value;
    ht_entry * next;
    ht_entry * prev;
};

typedef struct ht ht;
struct ht {
    ht_entry * entries;
    size_t capacity;
    size_t length;
};

ht* ht_create() {
    ht * hash_table = malloc(sizeof(ht));
    if (hash_table == NULL) {
        return NULL;
    }

    hash_table->length = 0;
    hash_table->capacity = HASHTABLE_SIZE;

    hash_table->entries = calloc(hash_table->capacity, sizeof(ht_entry));
    if (hash_table->entries == NULL) {
        free(hash_table);
        return NULL;
    }
    return hash_table;
}

unsigned long ht_hash(const char * key) {
    unsigned long hash = 5381;
    int c;

    while ((c = *key++)) {
        hash = ((hash << 5) + hash) + c;
    }

    return hash % HASHTABLE_SIZE;
}

ht_entry * ht_get(ht * ht, const char * key) {
    ht_entry * lookat = &ht->entries[ht_hash(key)];
    while (lookat != NULL) {
        if (lookat->key != NULL && strcmp(lookat->key, key) == 0) {
            return lookat;
        }
        lookat = lookat->next;
    }

    return NULL;
}

ht_entry * ht_add(ht * ht, const char * key, void * value) {
    unsigned long index = ht_hash(key);
    ht_entry * current = &ht->entries[index];
    ht_entry * prev_entry = NULL;

    // Posição vazia:
    if (current->key == NULL && current->next == NULL) {
        current->key = key;
        current->value = value;
        ht->length++;
        return current;
    }

    // Já existe, então só atualizar o valor
    while (current != NULL) {
        if (current->key != NULL && strcmp(current->key, key) == 0) {
            current->value = value;
            return current;
        }
        prev_entry = current;
        current = current->next;
    }

    ht_entry * newer_entry = calloc(1, sizeof(ht_entry));
    if (newer_entry == NULL) return NULL;

    newer_entry->key = key;
    newer_entry->value = value;
    newer_entry->prev = prev_entry;
    prev_entry->next = newer_entry;
    ht->length++;

    return newer_entry;
}

bool ht_destroy(ht * ht) {
    if (ht == NULL) return true;
    for (size_t i = 0; i < ht->capacity; i++) {
        ht_entry * current = ht->entries[i].next;
        while (current != NULL) {
            ht_entry * next = current->next;
            free(current);
            current = next;
        }
    }
    free(ht->entries);
    free(ht);

    return true;
}

bool ht_remove(ht * ht, const char * key) {
    ht_entry * tmp = ht_get(ht, key);
    if (tmp == NULL) return false;

    unsigned long index = ht_hash(key);
    ht_entry * base = &ht->entries[index];

    if (tmp == base) {
        if (tmp->next != NULL) {
            ht_entry * next_node = tmp->next;
            tmp->key = next_node->key;
            tmp->value = next_node->value;
            tmp->next = next_node->next;
            if (tmp->next != NULL) {
                tmp->next->prev = tmp;
            }
            free(next_node);
        } else {
            tmp->key = NULL;
            tmp->value = NULL;
        }
    } else {
        if (tmp->prev != NULL) tmp->prev->next = tmp->next;
        if (tmp->next != NULL) tmp->next->prev = tmp->prev;
        free(tmp);
    }

    ht->length--;
    return true;
}

void ht_print(ht * ht) {
    for (int i = 0; i < ht->capacity; i++) {
        ht_entry * current = &ht->entries[i];
        if (current->key == NULL && current->next == NULL) continue;

        while (current != NULL) {
            if (current->key != NULL) {
                printf("%d: %s\n", i, current->key);
            }
            current = current->next;
        }
    }
}

#endif

// int main(void) {
//     ht *table = ht_create();
//
//     // Hash table successfully created (reserved in memory):
//     assert(table != NULL);
//     // Check if the default fields are correct:
//     assert(table->capacity == HASHTABLE_SIZE);
//     assert(table->length == 0);
//
//     // Entries was also reserved, so it should not be NULL anymore:
//     assert(table->entries != NULL);
//     assert(table->entries[0].key == NULL);
//
//     const char * key1 = "test#var1";
//     const char * key2 = "test#var2";
//     const char * key3 = "test#var10";
//     const char * type = "u_int32";
//
//     // Successfully add:
//     assert(ht_add(table, key1, (void *)type) != NULL);
//     assert(ht_add(table, key3, (void *)type) != NULL);
//
//     assert(ht_get(table, key1) != NULL);
//     assert(ht_get(table, key3) != NULL);
//
//     assert(ht_remove(table, key1));
//     assert(ht_remove(table, key3));
//
//
//     // Key2 shouldn't show up
//     assert(ht_get(table, key2) == NULL);
//
//     // A 0 in strcmp means the strings are equal
//     assert(ht_add(table, key1, (void *)type) != NULL);
//     assert(strcmp((const char *)ht_get(table, key1)->value, type) == 0);
//
//     ht_print(table);
//
//     return 0;
// }