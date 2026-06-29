#include <stdio.h>
#include <stdlib.h>

#include "../../record.h"
#include "../parser.h"
#include "../semantics.h"

void handleOperandTypes(Record** $$, Record* expression1, Record* expression2, char* operator, char* expectedOperandType) {
    char* temp[] = {expression1->code, operator, expression2->code};

    if (!checkTypeCompat(expectedOperandType, expression1->type, BOTH) || !checkTypeCompat(expectedOperandType, expression2->type, BOTH)) {
        printf("ERROR Line %d: incompatible types with operator'%s'\n",
               yylineno, operator);
        exit(0);
    }

    char* temp2 = checkTypeCompat(expression1->type, expression2->type, BOTH);
    if (temp2) {
        *$$ = CreateRecordType(cat(temp, 3), temp2);
    } else {
        printf("ERROR Line %d: %s and %s are not interchangeable types\n",
               yylineno, expression1->type, expression2->type);
        exit(1);
    }
}
