#include "record.h"
#include <stdlib.h>
#include <string.h>

Record* CreateRecord(char* code) {
    Record* record = (Record*)malloc(sizeof(Record));
    record->code = strdup(code);
    record->returnType = NULL;
    return record;
}

ArrayType* newArrayType(c_code content, type expectedType, type* types, long long size) {
    ArrayType* t = (ArrayType*)malloc(sizeof(ArrayType));
    t->content = strdup(content);
    t->expectedType = strdup(expectedType);
    t->contentTypes = (type*)malloc(sizeof(type));
    for (int i = 0; i < size; ++i) {
        t->contentTypes[i] = strdup(types[i]);
    }
    t->size = size;
    return t;
}

TypeRec* newTypeRec(c_code c_code, type typeID, int size) {
    TypeRec* t = (TypeRec*)malloc(sizeof(TypeRec));
    t->c_code = strdup(c_code);
    t->type = strdup(typeID);
    t->size = size;
    return t;
}

Record* CreateRecordType(c_code c_code, type typeID) {
    Record* record = (Record*)malloc(sizeof(Record));
    record->code = strdup(c_code);
    record->type = strdup(typeID);
    record->returnType = NULL;
    return record;
}
Record* CreateRecordVarTyped(char* code, char* typeID, char* ID) {
    Record* record = (Record*)malloc(sizeof(Record));
    record->code = strdup(code);
    record->type = strdup(typeID);
    record->id = strdup(ID);
    record->returnType = NULL;
    return record;
}
Record* CreateRecordFunc(char* code, LinkedList* paramsTypes, char* returnType) {
    Record* record = (Record*)malloc(sizeof(Record));
    record->code = strdup(code);
    record->paramsTypes = paramsTypes;
    record->returnType = strdup(returnType);
    return record;
}
Record* CreateRecordFuncParams(char* code, LinkedList* paramsTypes) {
    Record* record = (Record*)malloc(sizeof(Record));
    record->code = strdup(code);
    record->paramsTypes = paramsTypes;
    record->returnType = NULL;
    return record;
}
Record* CreateRecordIO(char* code, char* prefix, char* sufix) {
    Record* record = (Record*)malloc(sizeof(Record));
    record->code = strdup(code);
    record->IOPrefix = strdup(prefix);
    record->IOSufix = strdup(sufix);
    record->returnType = NULL;
    return record;
}
void FreeRecord(Record* record) {
    if (record) {
        if (record->code != NULL)
            free(record->code);
        free(record);
    }
}
