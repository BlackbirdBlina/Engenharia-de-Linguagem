#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "../../record.h"
// #include "../semantics.h"
#include "../semantics.h"

void typeCheckIdExpression(ID_t $1, Record* $3) {
    type tempVarExpTypeCmp = checkTypeCompat(getVarType($1), $3->type, RIGHT_LEFT);
    if (tempVarExpTypeCmp != NULL) {
        return;
    }

    printf("ERROR: \"%s\" has type '%s', but got '%s'\n", $1, getVarType($1),
           $3->type);
    exit(1);
}

void attribute_id_expression(Record** $$, ID_t $1, Record* $3) {
    char* temp[] = {$1, "=", $3->code, ";"};
    checkVarScope($1);
    ASSIGN a = getVarAssign($1);
    if (a == CONSTANT) {
        printf("ERROR: the variable %s is constant", $1);
        exit(1);
    }
    if (a == STAT) {
        printf("ERROR: the variable %s is stat", $1);
        exit(1);
    }

    typeCheckIdExpression($1, $3);
    *$$ = CreateRecord(cat(temp, 4));
}
