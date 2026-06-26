#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "../../record.h"
#include "../semantics.h"

typedef enum { STAT, MUT, CONSTANT } ASSIGN;

void check_let__equal(Record *$2, Record *$4) {
    // let i : bool = false;
    // let i : bool = false;
    if (lookup_symbol(varTable, $2->id)) {
        printf("ERROR: \"%s\" was already declared\n", $2->id);
        exit(1);
    }
    char *tempVarExpTypeCmp = checkTypeCompatibility($2->type, $4->type);
    // Se der certo, não retorna nada:
    if (tempVarExpTypeCmp != NULL) {
        if (strcmp(tempVarExpTypeCmp, $2->type) == 0) {
            return;
        }
    }
    // let i : bool = 10;
    printf("ERROR: \"%s\" has type '%s', but got type '%s'\n", $2->id, $2->type,
           $4->type);
    exit(1);
}

void let__equal(Record **$$, Record *varTyped, Record *expression, ASSIGN a) {
    // FUTURAMENTE MUDAR DE ACORDO COM O ASSIGN
    // if (a == STAT) {
    //     printf("STATIC\n");
    // } else if (a == MUT) {
    //     printf("MUTABLE\n");
    // } else if (a == CONSTANT) {
    //     printf("CONSTANT\n");
    // }
    char *temp[] = {"const ", varTyped->code, " = ", expression->code, ";"};
    *$$ = CreateRecord(cat(temp, 5));
    check_let__equal(varTyped, expression);
    insert_symbol(varTable, varTyped->id,
                  alloc_type_var(varTyped->type, scopeStack->top->scopeName));
}

// : setlocal commentstring=//\ %s
