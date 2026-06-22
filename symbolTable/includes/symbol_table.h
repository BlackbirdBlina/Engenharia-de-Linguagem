#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#define TABLE_SIZE 211

typedef enum {
    KIND_BOOL, KIND_S_INT8, KIND_S_INT32, KIND_S_SIZE, KIND_S_INT16,
    KIND_U_INT8, KIND_U_INT16, KIND_U_INT32, KIND_U_SIZE,
    KIND_FLOAT32, KIND_FLOAT64, KIND_CHAR, KIND_STRING,
    KIND_VEC, KIND_SET, KIND_MATRIX, KIND_RESULT, KIND_OPTION,
    KIND_ARRAY, KIND_REF_ARRAY, KIND_REF, KIND_UNIT, KIND_USER_DEFINED
} TypeKind;

typedef struct TypeInfo {
    TypeKind kind;
    struct TypeInfo* element_type;
    struct TypeInfo* secondary_type;
    int dimensions[2];
    char* user_type_name;
} TypeInfo;

typedef struct SymbolNode {
    char* key;
    char* name;
    TypeInfo* type;
    struct SymbolNode* next;
} SymbolNode;

typedef struct {
    SymbolNode* bucket[TABLE_SIZE];
} SymbolTable;

extern int global_counter;

TypeInfo* create_primitive_type(TypeKind kind);
TypeInfo* create_user_type(const char* name);
void free_type_info(TypeInfo* type);

SymbolTable* create_table(void);
unsigned int hash(const char* key);
char* generate_key(const char* id, const char* scope);
void insert_symbol(SymbolTable* table, const char* id, const char* scope, TypeInfo* type);
SymbolNode* lookup_symbol(SymbolTable* table, const char* unique_key);
void free_table(SymbolTable* table);

#endif