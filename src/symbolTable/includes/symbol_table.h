#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#define TABLE_SIZE 211

#include <stdint.h>
#include <sys/types.h>
#include <stdbool.h>

typedef enum {
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
} TypeKind;

typedef struct Vec {

} Vec;

typedef struct Set {

} Set;

typedef struct Matrix {
    int dimensions[2];
} Matrix;

typedef struct Result {
    struct TypeInfo* okType;
    struct TypeInfo* errortype;
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

} User_struct;

typedef struct User_enum {

} User_enum;

typedef struct TypeInfo {
    TypeKind kind;
    char* user_type_name;
    union SpecificType {
        bool bool_infos;
        int8_t s_int8_infos;
        int16_t s_int16_infos;
        int32_t s_int32_infos;
        ssize_t s_size_infos;
        uint8_t u_int8_infos;
        uint16_t u_int16_infos;
        uint32_t u_int32_infos;
        size_t u_size_infos;
        float float32_infos;
        double float64_infos;
        char char_infos;
        char* string_infos;
        Vec vec_infos;
        Set set_infos;
        Matrix matrix_infos;
        Result result_infos;
        Option option_infos;
        Array array_infos;
        Ref_array ref_array_infos;
        Ref ref_infos;
        Unit unit_infos;
        User_struct user_struct_infos;
        User_enum user_enum_infos;
    } specific_info;
} TypeInfo;

typedef struct SymbolNode {
    char* key;
    char* name;
    TypeInfo* type;
    struct SymbolNode* next;
} SymbolNode;

typedef struct {
    SymbolNode* buckets[TABLE_SIZE];
} SymbolTable;

extern int global_counter;

TypeInfo* create_primitive_type(TypeKind kind);
TypeInfo* create_user_type(const char* name, TypeKind kind);
void free_type_info(TypeInfo* type);

SymbolTable* create_table(void);
unsigned int hash(const char* key);
char* generate_key(const char* id, const char* scope);
void insert_symbol(SymbolTable* table, const char* id, const char* scope, TypeInfo* type);
SymbolNode* lookup_symbol(SymbolTable* table, const char* unique_key);
void free_table(SymbolTable* table);

#endif