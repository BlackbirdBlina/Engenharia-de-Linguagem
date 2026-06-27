#include "record.h"
#include <stdlib.h>
#include <string.h>

Record *CreateRecord(char *code) {
    Record *record = (Record *)malloc(sizeof(Record));
    record->code = strdup(code);
    return record;
}
Record *CreateRecordType(char *code, char *typeID) {
    Record *record = (Record *)malloc(sizeof(Record));
    record->code = strdup(code);
    record->type = strdup(typeID);
    return record;
}
Record *CreateRecordVarTyped(char *code, char *typeID, char *ID) {
    Record *record = (Record *)malloc(sizeof(Record));
    record->code = strdup(code);
    record->type = strdup(typeID);
    record->id = strdup(ID);
    return record;
}
Record *CreateRecordFunc(char *code, LinkedList* paramsTypes,char *returnType){
    Record *record = (Record *)malloc(sizeof(Record));
    record->code = strdup(code);
    record->paramsTypes = paramsTypes;
    record->returnType = strdup(returnType);
    return record;
}
Record *CreateRecordFuncParams(char *code, LinkedList* paramsTypes){
    Record *record = (Record *)malloc(sizeof(Record));
    record->code = strdup(code);
    record->paramsTypes = paramsTypes;
    return record;
}
Record *CreateRecordIO(char *code, char *prefix, char *sufix) {
    Record *record = (Record *)malloc(sizeof(Record));
    record->code = strdup(code);
    record->IOPrefix = strdup(prefix);
    record->IOSufix = strdup(sufix);
    return record;
}
void FreeRecord(Record *record) {
    if (record) {
        if (record->code != NULL)
            free(record->code);
        free(record);
    }
}
