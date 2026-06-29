#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "../../record.h"
#include "../../symbol_table.h"
#include "../semantics.h"

void check_let__equal(Record* $2, Record* $4) {
    // let i : bool = false;
    // let i : bool = false;
    if (search_var_in_currentScope($2->id)) {
        printf("ERROR: \"%s\" was already declared\n", $2->id);
        exit(1);
    }

    char* tempVarExpTypeCmp = checkTypeCompat($2->type, $4->type, RIGHT_LEFT);

    // Se der certo, não retorna nada:
    if (tempVarExpTypeCmp != NULL) {
        return;
    }

    // let i : bool = 10;
    printf("ERROR: \"%s\" has type '%s', but got type '%s'\n", $2->id, $2->type,
           $4->type);
    exit(1);
}

void let__equal(Record** $$, Record* varTyped, Record* expression, ASSIGN a) {
    switch (a) {
    case STAT:
        char* temp[] = {"const ", varTyped->code, " = ", expression->code, ";"};
        *$$ = CreateRecord(cat(temp, 5));
        check_let__equal(varTyped, expression);
        store_var_in_varTable(varTyped->id, varTyped->type, STAT);
        break;
    case MUT:
        char* temp1[] = {varTyped->code, " = ", expression->code, ";"};
        check_let__equal(varTyped, expression);
        store_var_in_varTable(varTyped->id, varTyped->type, MUT);
        *$$ = CreateRecord(cat(temp1, 4));
        break;
    case CONSTANT:
        char* temp2[] = {"const ", varTyped->code, " = ", expression->code, ";"};
        *$$ = CreateRecord(cat(temp2, 5));
        check_let__equal(varTyped, expression);
        store_var_in_varTable(varTyped->id, varTyped->type, CONSTANT);
        break;

    default:
        printf("ERROR: Assigment not defined");
        exit(1);
        break;
    }
}

// : setlocal commentstring=//\ %s
