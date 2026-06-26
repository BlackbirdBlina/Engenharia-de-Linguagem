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

Record *CreateRecord(char *);
Record *CreateRecordType(char *, char *);
Record *CreateRecordPrint(char *, char *, char *);
Record *CreateRecordVarTyped(char *, char *, char *);
Record *CreateRecordFunc(char *, int, char **, char *);
Record *CreateRecordFuncParams(char *, int, char **);
void FreeRecord(Record *);
#endif
