#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "../../record.h"
// #include "../semantics.h"
#include "../parser.h"
#include "../semantics.h"

void typeCheckIdExpression(ID_t $1, Record* $3) {
    type tempVarExpTypeCmp = checkTypeCompat(getVarType($1), $3->type, RIGHT_LEFT);
    if (tempVarExpTypeCmp != NULL) {
        return;
    }

    printf("ERROR Line %d: \"%s\" has type '%s', but got '%s'\n",
           yylineno, $1, getVarType($1), $3->type);
    exit(1);
}

void checkMutable(ID_t id) {
    ASSIGN a = getVarAssign(id);
    if (a == CONSTANT) {
        printf("ERROR Line %d: \"%s\" is a constant\n",
               yylineno, id);
        exit(1);
    }
    if (a == STAT) {
        printf("ERROR Line %d: \"%s\" is not mutable\n",
               yylineno, id);
        exit(1);
    }

    return;
}

void attribute_id_expression(Record** $$, ID_t $1, Record* $3) {
    char* temp[] = {$1, " = ", $3->code, ";"};
    checkVarScope($1);

    // Only continue if mutable:
    checkMutable($1);

    typeCheckIdExpression($1, $3);
    *$$ = CreateRecord(cat(temp, 4));
}
void attribute_struct_expression(Record** $$, Record* structAcess, Record* Expression) {
    char* temp[] = {structAcess->code, " = ", Expression->code, ";"};
    checkMutable(structAcess->id);

    type checkTypes = checkTypeCompat(structAcess->type, Expression->type, RIGHT_LEFT);
    if (checkTypes == NULL) {
        printf("ERROR Line %d: \"%s\" expects \"%s\", received \"%s\"\n",
               yylineno, structAcess->code, structAcess->type, Expression->type);
        exit(1);
    }
    *$$ = CreateRecord(cat(temp, 4));
}

void attribute_array_expression(Record** $$, Record* Array_, Record* Expression_) {

    checkVarScope(Array_->id);
    checkMutable(Array_->id);
    type checkTypes = checkTypeCompat(Array_->type, Expression_->type, RIGHT_LEFT);
    if (checkTypes == NULL) {
        printf("ERROR Line %d: \"%s\" expects \"%s\", received \"%s\"\n",
               yylineno, Array_->id, Array_->type, Expression_->type);
        exit(1);
    }

    // TODO: CHECK IF a[9] and Array_->id has that same size of 9

    char* temp[] = {Array_->code, " = ", Expression_->code, ";"};

    *$$ = CreateRecord(cat(temp, 4));
}
