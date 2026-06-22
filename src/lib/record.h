#ifndef RECORD
#define RECORD

    struct Record{
        char* code;
    }; typedef struct Record Record;
    
    Record * CreateRecord(char*);
    void FreeRecord(Record *);
#endif