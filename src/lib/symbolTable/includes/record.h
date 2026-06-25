#ifndef RECORD
#define RECORD

#include<symbol_table.h>

typedef struct Record{
    char* code;
    TypeKind kind;
    char* id;
} Record;


Record* CreateRecord(char*);
Record* CreateTypedRecord(char* code, TypeKind kind);
void FreeRecord(Record *);

#endif