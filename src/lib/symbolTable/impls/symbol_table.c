#include "symbol_table.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int global_counter = 0;

TypeInfo* alloc_type_info(TypeKind kind) {
    TypeInfo* typeInfo = (TypeInfo*)malloc(sizeof(TypeInfo));
    if (!typeInfo) return NULL;
    typeInfo->kind = kind;
    return typeInfo;
}

unsigned int hash(const char* key) {
    unsigned long hash = 5381;
    int character;
    while ((character = (unsigned char)*key++)) {
        hash = ((hash << 5) + hash) + character;
    }
    return hash % TABLE_SIZE;
}

char* generate_key(const char* id, const char* scope) {
    char buffer[512];
    snprintf(buffer, sizeof(buffer), "%s#%s#%d", id, scope, global_counter++);
    return strdup(buffer);
}

SymbolTable* create_table(void) {
    SymbolTable* table = (SymbolTable*)malloc(sizeof(SymbolTable));
    if (!table) return NULL;
    for (int i = 0; i < TABLE_SIZE; i++) {
        table->buckets[i] = NULL;
    }
    return table;
}

void insert_symbol(SymbolTable* table, const char* id, const char* scope, TypeInfo* type) {
    if (!table || !id || !scope) {
        printf("Não foi possível realizar a inserção, pois houve um problema na tabela, no id ou no escopo.\n");
        return;
    }

    char* unique_key = generate_key(id, scope);
    unsigned int slot = hash(unique_key);

    SymbolNode* new_node = (SymbolNode*)malloc(sizeof(SymbolNode));
    if (!new_node) {
        free(unique_key);
        printf("Não foi possível gerar um novo nó para armazenar a informação.\n");
        return;
    }

    new_node->key = unique_key;
    new_node->name = strdup(id);
    new_node->type = type;
    if (table->buckets[slot] != NULL) {
        SymbolNode* current = table->buckets[slot];
        while (current->next != NULL) {
            current = current->next;
        }
        current->next = new_node;
    } else {
        table->buckets[slot] = new_node;
    }
}

SymbolNode* lookup_symbol(SymbolTable* table, const char* unique_key) {
    if (!table || !unique_key) {
        printf("Tabela não inicializada ou chave não informada.\n");
        return NULL;
    }

    unsigned int slot = hash(unique_key);
    SymbolNode* current = table->buckets[slot];

    while(current != NULL) {
        if (strcmp(current->key, unique_key) == 0) {
            return current;
        }
        current = current->next;
    }
    printf("Informação buscada não encontrada.\n");
    return NULL;
}