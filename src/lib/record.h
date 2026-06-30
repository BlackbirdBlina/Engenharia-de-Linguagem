#ifndef RECORD
#define RECORD

#include "linked_list.h"
#include "parser/types.h"
#include "symbol_table.h"
struct Record {
    c_code code;
    type type;
    char* id;

    LinkedList* paramsTypes;
    SymbolTable* structFields;
    type returnType;

    char* IOPrefix;
    char* IOSufix;

    int sizeOfArrayAccess;
};
typedef struct Record Record;

struct TypeRec {
    c_code c_code;
    type type;
    int size;
};
typedef struct TypeRec TypeRec;
TypeRec* newTypeRec(c_code code, type typeID, int size);

// let a : [u_int16; 2] = {0, 1};
// ...int a[2] = {0, 1}
struct ArrayType {
    c_code content; // { 0, 1, ... }
    type type;      // u_int16
    long long size; // 2
};
typedef struct ArrayType ArrayType;
ArrayType* newArrayType(c_code code, type type, long long size);

Record* CreateRecord(char* code);
Record* CreateRecordType(char* code, type typeID);
Record* CreateRecordVarTyped(char* code, char* typeID, char* ID);
Record* CreateRecordFunc(char* code, LinkedList* paramsTypes, char* returnType);
Record* CreateRecordFuncParams(char* code, LinkedList* paramsTypes);
Record* CreateRecordIO(char* code, char* prefix, char* sufix);
Record* CreateRecordArrayAccess(char* code, int sizeOfArrayAccess);
Record* CreateRecordAttributes(char* code, SymbolTable* fields);

void FreeRecord(Record*);
#endif
