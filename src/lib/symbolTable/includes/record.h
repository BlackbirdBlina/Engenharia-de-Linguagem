#ifndef RECORD
#define RECORD

#include<symbol_table.h>

typedef struct Record{
    char* code;
    TypeKind kind;
    
} Record;


Record * CreateRecord(char*);
Record* CreateTypeRecord(char* code, TypeKind kind);
void FreeRecord(Record *);

#endif