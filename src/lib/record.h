#ifndef RECORD
#define RECORD

struct Record {
    char *code;
    char *type;
    char *id;

    char **funcParamsTypes;
    int funcParamsQnt;

    char *printPrefix;
    char *printSufix;
};
typedef struct Record Record;

Record *CreateRecord(char *code);
Record *CreateRecordType(char *code, char *typeID);
Record *CreateRecordVarTyped(char *code, char *typeID, char *ID);
Record *CreateRecordFunc(char *code, int paramsQnt, char **paramsTypes,
                         char *returnType);
Record *CreateRecordFuncParams(char *code, int paramsQnt, char **paramsTypes);
Record *CreateRecordPrint(char *code, char *prefix, char *sufix);

void FreeRecord(Record *);
#endif
