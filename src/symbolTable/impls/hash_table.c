#include "symbol_table.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int global_counter = 0;

TypeInfo* create_primitive_type(TypeKind kind) {
    TypeInfo* typeInfo = (TypeInfo*)malloc(sizeof(TypeInfo));
    if (!typeInfo) return NULL;
    typeInfo->kind = kind;
    typeInfo->element_type = NULL;
    typeInfo->secondary_type = NULL;
    typeInfo->user_type_name = NULL;
    typeInfo->dimensions[0] = 0;
    typeInfo->dimensions[1] = 0;
    return typeInfo;
}

TypeInfo* create_user_type(const char* name) {
    TypeInfo* typeInfo = create_primitive_type(KIND_USER_DEFINED);
    if(typeInfo && name) {
        typeInfo->user_type_name = strdup(name);
    }
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