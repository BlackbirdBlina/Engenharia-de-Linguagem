#include "../../record.h"
#include "../semantics.h"
#include <stdlib.h>
#include <string.h>

void print_to_print(Record **$$, Record *$3) {
    char *temp[] = {"printf(\"", $3->printPrefix, "\",", $3->printSufix, ")"};
    *$$ = CreateRecord(cat(temp, 5));
};

void ID_toPrint(Record **$$, ID_t $1, Record *$3) {
    char *tmpPrintPrefix[] = {"VAR", $3->printPrefix};
    char *tmpPrintSuffix[] = {$1, ",", $3->printSufix};
    *$$ = CreateRecordPrint("", cat(tmpPrintPrefix, 2), cat(tmpPrintPrefix, 3));
};

void VALUE_STRING_t_toPrint(Record **$$, VALUE_STRING_t $1, Record *$3) {
    char *tempString = malloc(sizeof($1) - 2);
    for (int i = 0; i < strlen($1) - 2; i++) {
        tempString[i] = $1[i + 1];
    }
    char *tempprintPrefix[] = {tempString, $3->printPrefix};
    *$$ = CreateRecordPrint("", cat(tempprintPrefix, 2), $3->printSufix);
}

void print_VALUE_STRING_t(Record **$$, VALUE_STRING_t $1) {
    char *tempString = malloc(sizeof($1) - 2);
    for (int i = 0; i < strlen($1) - 2; i++) {
        tempString[i] = $1[i + 1];
    }
    *$$ = CreateRecordPrint("", tempString, "");
}
