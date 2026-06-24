#include "record.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

Record* CreateRecord(char* code){
    Record * record= (Record*)malloc(sizeof(Record));
    record->code=strdup(code);
    return record;
}

Record* CreateTypeRecord(char* code, TypeKind kind) {
    Record* record = (Record*)malloc(sizeof(Record));
    record->code = strdup(code);
    record->kind = kind;
    return record;
}

void FreeRecord(Record* record){
    if (record) {
    if (record->code != NULL) free(record->code);
    free(record);
  }
}