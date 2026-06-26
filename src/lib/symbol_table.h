#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#define TABLE_SIZE 211

#define bool_ "bool"
#define s_int16 "s_int16"
#define s_int32 "s_int32"
#define s_int64 "s_int64"
#define s_size "s_size"
#define u_int16 "u_int16"
#define u_int32 "u_int32"
#define u_int64 "u_int64"
#define u_size "u_size"
#define float32 "float32"
#define float64 "float64"
#define char_ "char"
#define literal_int "literal_int"
#define literal_float "literal_float"

#include <stdbool.h>
#include <sys/types.h>
#include "linked_list.h"

typedef char* type;

typedef struct SymbolInfo {

    type type;
    char *scope;

    const char **conversions;
    int conversionsQnt;

    LinkedList* typeParams;
} SymbolInfo;

typedef struct SymbolNode {
    char *key;
    char *name;
    SymbolInfo *info;
    struct SymbolNode *next;
} SymbolNode;

typedef struct {
    SymbolNode *buckets[TABLE_SIZE];
} SymbolTable;

extern int global_counter;

// SymbolInfo* alloc_type_info(TypeKind kind);
SymbolInfo *alloc_type_var(char *type, char *scope);
SymbolInfo *alloc_type_type(char *type, const char **conversions,int conversionsQnt);
SymbolInfo *alloc_type_func(char *returnType, LinkedList* paramsList);
void free_type_info(SymbolInfo *info);
SymbolTable *create_table();
unsigned int hash(const char *key);
void insert_symbol(SymbolTable *table, const char *id, SymbolInfo *info);
SymbolNode *lookup_symbol(SymbolTable *table, const char *unique_key);
void free_table(SymbolTable *table);

#endif
