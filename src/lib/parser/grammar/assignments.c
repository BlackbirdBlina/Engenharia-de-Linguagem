#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "../../record.h"
#include "../semantics.h"

void check_let_equal(Record *$$, Record *$2, Record *$4) {
    // If symbol already in symbol table
    if (lookup_symbol(varTable, $2->id)) {
        printf("ERROR: \"%s\" was already declared\n", $2->id);
        exit(1);
    }
    // If Types are compatible
    char *tempVarExpTypeCmp = checkTypeCompatibility($2->type, $4->type);
    if (tempVarExpTypeCmp) {
        if (strcmp(tempVarExpTypeCmp, $2->type) != 0) {
            printf("ERROR: \"%s\" receives %s but received %s", $2->id,
                   $2->type, $4->type);
            exit(1);
        }
    } else {
        printf("ERROR: \"%s\" recebe %s recebeu %s", $2->id, $2->type,
               $4->type);
        exit(1);
    }
}
// : setlocal commentstring=//\ %s
