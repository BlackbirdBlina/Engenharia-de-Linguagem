#ifndef RECORD
#define RECORD

#include "linked_list.h"
#include "parser/types.h"

struct Record {
    c_code code;
    type type;
    char* id;

    LinkedList* paramsTypes;
    type returnType;

    char* IOPrefix;
    char* IOSufix;
};
typedef struct Record Record;

struct TypeRec {
    c_code c_code;
    type type;
    int size;
};
typedef struct TypeRec TypeRec;
TypeRec* newTypeRec(c_code code, type typeID, int size);

struct ArrayType {
    c_code content;
    type expectedType;
    type* contentTypes;
    long long size;
};
typedef struct ArrayType ArrayType;
ArrayType* newArrayType(c_code code, type expectedType, type* types, long long size);

Record* CreateRecord(char* code);
Record* CreateRecordType(char* code, type typeID);
Record* CreateRecordVarTyped(char* code, char* typeID, char* ID);
Record* CreateRecordFunc(char* code, LinkedList* paramsTypes, char* returnType);
Record* CreateRecordFuncParams(char* code, LinkedList* paramsTypes);
Record* CreateRecordIO(char* code, char* prefix, char* sufix);

void FreeRecord(Record*);
#endif
