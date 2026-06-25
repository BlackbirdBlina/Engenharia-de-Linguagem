#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#define TABLE_SIZE 211

#include <stdint.h>
#include <sys/types.h>
#include <stdbool.h>

/*typedef enum {
    KIND_BOOL, 
    KIND_S_INT8, 
    KIND_S_INT16,
    KIND_S_INT32, 
    KIND_S_SIZE,
    KIND_U_INT8, 
    KIND_U_INT16, 
    KIND_U_INT32, 
    KIND_U_SIZE, 
    KIND_FLOAT32,
    KIND_FLOAT64, 
    KIND_CHAR, 
    KIND_STRING,
    KIND_VEC, 
    KIND_SET, 
    KIND_MATRIX, 
    KIND_RESULT, 
    KIND_OPTION,
    KIND_ARRAY, 
    KIND_REF_ARRAY, 
    KIND_REF, 
    KIND_UNIT, 
    KIND_USER_STRUCT,
    KIND_USER_ENUM 
} TypeKind;*/

typedef struct Vec {

} Vec;

typedef struct Set {

} Set;

typedef struct Matrix {
    int dimensions[2];
} Matrix;

typedef struct Result {
    struct SymbolInfo* okType;
    struct SymbolInfo* errortype;
} Result;

typedef struct Option {

} Option;

typedef struct Array {
    
} Array;

typedef struct Ref_array {

} Ref_array;

typedef struct Ref {

} Ref;

typedef struct Unit {

} Unit;

typedef struct User_struct {
    char* user_type_name;

} User_struct;

typedef struct User_enum {
    char* user_type_name;

} User_enum;

typedef struct SymbolInfo {
    
    char* type;
    char* scope;

    const char** conversions;
    int conversionsQnt;
    
} SymbolInfo;

typedef struct SymbolNode {
    char* key;
    char* name;
    SymbolInfo* info;
    struct SymbolNode* next;
} SymbolNode;

typedef struct {
    SymbolNode* buckets[TABLE_SIZE];
} SymbolTable;

extern int global_counter;

//SymbolInfo* alloc_type_info(TypeKind kind);
SymbolInfo* alloc_type_var(char* type, char* scope);
SymbolInfo* alloc_type_type(char* type, const char** conversions,int conversionsQnt);
void free_type_info(SymbolInfo* info);
SymbolTable* create_table();
unsigned int hash(const char* key);
void insert_symbol(SymbolTable* table, const char* id,SymbolInfo* info);
SymbolNode* lookup_symbol(SymbolTable* table, const char* unique_key);
void free_table(SymbolTable* table);

#endif