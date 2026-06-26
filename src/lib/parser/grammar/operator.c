#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "../../record.h"
#include "../semantics.h"

void handle_operands_types(Record** $$,Record* $1,Record* $3,char* operator,char* type_operand_expected){
    char* temp[]={$1->code,operator,$3->code};
    if (!checkTypeCompatibility(type_operand_expected,$1->type) || !checkTypeCompatibility(type_operand_expected,$3->type)) {
        printf("ERROR: incomtatible types with operator'%s'",operator);
        exit(0);
    }
    char * temp2 = checkTypeCompatibility($1->type,$3->type);
    if (temp2) {
        *$$=CreateRecordType(cat(temp,3),temp2);
    }
    else {
        printf("ERROR: %s and %s are not interchangeable types\n", $1->type, $3->type);
        exit(1);
    }
}

