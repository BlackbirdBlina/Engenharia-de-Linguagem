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
void FreeRecord(Record *record) {
  if (record) {
    if (record->code != NULL)
      free(record->code);
    free(record);
  }
}
