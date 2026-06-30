#include "symbol_table.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

SymbolInfo* alloc_type_var(type t, char* scope, ASSIGN assign) {
    SymbolInfo* symbolInfo = (SymbolInfo*)malloc(sizeof(SymbolInfo));
    if (!symbolInfo) {
        return NULL;
    }
    symbolInfo->type = t;
    symbolInfo->scope = scope;
    symbolInfo->assign = assign;
    symbolInfo->isArrayOf = NULL;
    symbolInfo->isRefOf = NULL;
    symbolInfo->structFields = NULL;
    return symbolInfo;
}
SymbolInfo* allocTypeRef(type t, type isRefOf) {
    SymbolInfo* symbolInfo = (SymbolInfo*)malloc(sizeof(SymbolInfo));
    if (!symbolInfo)
        return NULL;
    symbolInfo->type = t;
    symbolInfo->isArrayOf = NULL;
    symbolInfo->isRefOf = isRefOf;
    symbolInfo->size = 0;
    symbolInfo->conversions = NULL;
    symbolInfo->conversionsQnt = 0;
    symbolInfo->structFields = NULL;
    return symbolInfo;
}
SymbolInfo* allocTypeArray(type t, type isArrayOf, long long size) {
    SymbolInfo* symbolInfo = (SymbolInfo*)malloc(sizeof(SymbolInfo));
    if (!symbolInfo) {
        return NULL;
    }
    symbolInfo->type = t;
    symbolInfo->isArrayOf = isArrayOf;
    symbolInfo->isRefOf = NULL;
    symbolInfo->size = size;
    symbolInfo->conversions = NULL;
    symbolInfo->conversionsQnt = 0;
    symbolInfo->structFields = NULL;
    return symbolInfo;
}
SymbolInfo* alloc_type_type(type t, const char** conversions, int conversionsQnt) {
    SymbolInfo* symbolInfo = (SymbolInfo*)malloc(sizeof(SymbolInfo));
    if (!symbolInfo) {
        return NULL;
    }
    symbolInfo->type = t;
    symbolInfo->conversionsQnt = conversionsQnt;
    if (conversionsQnt > 0) {
        symbolInfo->conversions =
            (const char**)malloc(conversionsQnt * sizeof(const char*));
        for (int i = 0; i < conversionsQnt; i++) {
            symbolInfo->conversions[i] = conversions[i];
        }
    } else {
        symbolInfo->conversions = NULL;
    }
    symbolInfo->isArrayOf = NULL;
    symbolInfo->isRefOf = NULL;
    symbolInfo->size = 0;
    symbolInfo->structFields = NULL;
    return symbolInfo;
}
SymbolInfo* alloc_type_typeStructField(type t) {
    SymbolInfo* symbolInfo = (SymbolInfo*)malloc(sizeof(SymbolInfo));
    if (!symbolInfo) {
        return NULL;
    }
    symbolInfo->type = t;
    symbolInfo->conversionsQnt = 0;
    symbolInfo->isArrayOf = NULL;
    symbolInfo->isRefOf = NULL;
    symbolInfo->size = 0;
    symbolInfo->structFields = NULL;

    return symbolInfo;
}
SymbolInfo* alloc_type_typeStruct(type t, SymbolTable* structFields) {
    SymbolInfo* symbolInfo = (SymbolInfo*)malloc(sizeof(SymbolInfo));
    if (!symbolInfo) {
        return NULL;
    }
    symbolInfo->type = t;
    symbolInfo->conversionsQnt = 0;
    symbolInfo->isArrayOf = NULL;
    symbolInfo->isRefOf = NULL;
    symbolInfo->size = 0;
    symbolInfo->structFields = structFields;
    return symbolInfo;
}
SymbolInfo* alloc_type_func(type returnType, LinkedList* paramsList) {
    SymbolInfo* symbolInfo = (SymbolInfo*)malloc(sizeof(SymbolInfo));
    if (!symbolInfo) {
        return NULL;
    }
    symbolInfo->type = returnType;
    symbolInfo->typeParams = paramsList;
    symbolInfo->isArrayOf = NULL;
    symbolInfo->isRefOf = NULL;
    symbolInfo->structFields = NULL;
    return symbolInfo;
}
unsigned int hash(const char* key) {
    unsigned long hash = 5381;
    int character;
    while ((character = (unsigned char)*key++)) {
        hash = ((hash << 5) + hash) + character;
    }
    return hash % TABLE_SIZE;
}

SymbolTable* create_table() {
    SymbolTable* table = (SymbolTable*)malloc(sizeof(SymbolTable));
    if (!table)
        return NULL;
    for (int i = 0; i < TABLE_SIZE; i++) {
        table->buckets[i] = NULL;
    }
    return table;
}

void insert_symbol(SymbolTable* table, const char* id, SymbolInfo* info) {
    if (!table || !id) {
        printf(
            "Não foi possível realizar a inserção, pois houve um problema na "
            "tabela, no id ou no escopo.\n");
        return;
    }
    char* unique_key = strdup(id);
    unsigned int slot = hash(unique_key);

    SymbolNode* new_node = (SymbolNode*)malloc(sizeof(SymbolNode));
    if (!new_node) {
        free(unique_key);
        printf(
            "Não foi possível gerar um novo nó para armazenar a informação.\n");
        return;
    }

    new_node->key = unique_key;
    new_node->name = strdup(id);
    new_node->info = info;
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
        printf("Table not initialized OR key was not informed.\n");
        return NULL;
    }

    unsigned int slot = hash(unique_key);
    SymbolNode* current = table->buckets[slot];

    while (current != NULL) {
        if (strcmp(current->key, unique_key) == 0) {
            return current;
        }
        current = current->next;
    }
    return NULL;
}
