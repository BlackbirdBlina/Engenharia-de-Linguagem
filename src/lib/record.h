#ifndef RECORD
#define RECORD

#include "linked_list.h"

struct Record {
    char *code;
    char *type;
    char *id;
    
    LinkedList* paramsTypes;
    char *returnType;

    char *IOPrefix;
    char *IOSufix;
};
typedef struct Record Record;

Record *CreateRecord(char *code);
Record *CreateRecordType(char *code, char *typeID);
Record *CreateRecordVarTyped(char *code, char *typeID, char *ID);
Record *CreateRecordFunc(char *code, LinkedList* paramsTypes,char *returnType);
Record *CreateRecordFuncParams(char *code, LinkedList* paramsTypes);
Record *CreateRecordIO(char *code, char *prefix, char *sufix);

void FreeRecord(Record *);
#endif
