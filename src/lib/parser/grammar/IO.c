#include "../../record.h"
#include "../semantics.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// TODO: Falta adicionar o char* (acho que é o nosso string?)
// TODO: BOOL EM C FICA COMO??
// TODO: ACHO QUE FALTA IMPLEMENTAR O U_SIZE E S_SIZE

str checkPrefix(type t) {
    if (strcmp(t, bool_) == 0)
        return "%d";
    if (strcmp(t, s_int16) == 0)
        return "%hd";
    if (strcmp(t, s_int32) == 0)
        return "%d";
    if (strcmp(t, s_int64) == 0)
        return "%lld";
    if (strcmp(t, s_size) == 0)
        return "%lld";
    if (strcmp(t, u_int16) == 0)
        return "%hu";
    if (strcmp(t, u_int32) == 0)
        return "%u";
    if (strcmp(t, u_int64) == 0)
        return "%llu";
    if (strcmp(t, u_size) == 0)
        return "%lu";
    if (strcmp(t, float32) == 0)
        return "%f";
    if (strcmp(t, float64) == 0)
        return "%lf";
    if (strcmp(t, char_) == 0)
        return "%c";
    // if (strcmp(t, literal_int) == 0)
    //     return "%d";
    // if (strcmp(t, literal_float) == 0)
    //     return "%d";
    return NULL;
}
void check_type_prefix(str prefix, ID_t $1) {

    // If the type for the prefix is not predictable:
    if (prefix == NULL) {
        printf("ERROR: \"%s\"'s type '%s' is not printable\n", $1,
               getVarType($1));
        exit(1);
    }
}

// TODO: Verificar se as variáveis existem
void PRINT_toPrint(Record **$$, Record *$3) {
    // Quando tem prefixo, com vírgula
    if (strcmp($3->IOSufix, "") != 0) {
        char *temp[] = {"printf(\"", $3->IOPrefix, "\",", $3->IOSufix, ");"};
        *$$ = CreateRecord(cat(temp, 5));
    }
    // Quando não tem, sem vírgula
    else {
        char *temp[] = {"printf(\"", $3->IOPrefix, "\");"};
        *$$ = CreateRecord(cat(temp, 3));
    }
};

void ID_toPrint(Record **$$, ID_t $1, Record *$3) {
    // TODO: O que aconteceria se getvartype é null?
    // type try_get = getVarType($1);

    // TODO: Make this better, tá meio improvisado:
    checkVarScope($1);
    str prefix = checkPrefix(getVarType($1));
    check_type_prefix(prefix, $1);

    char *tmpPrintPrefix[] = {checkPrefix(getVarType($1)), $3->IOPrefix};
    if (strcmp($3->IOSufix, "") != 0) { // caso haja algum sufixo existente
        char *tmpPrintSufix[] = {$1, ",", $3->IOSufix};
        *$$ = CreateRecordIO("", cat(tmpPrintPrefix, 2), cat(tmpPrintSufix, 3));
    } else {
        *$$ = CreateRecordIO("", cat(tmpPrintPrefix, 2), $1);
    }
};

void VALUE_STRING_toPrint(Record **$$, VALUE_STRING_t $1, Record *$3) {
    char *tempString = malloc(sizeof($1) - 2);
    for (int i = 0; i < strlen($1) - 2; i++) {
        tempString[i] = $1[i + 1];
    }
    char *tempprintPrefix[] = {tempString, $3->IOPrefix};
    *$$ = CreateRecordIO("", cat(tempprintPrefix, 2), $3->IOSufix);
}

void print_VALUE_STRING(Record **$$, VALUE_STRING_t $1) {

    char *tempString = malloc(sizeof($1) - 2);
    for (int i = 0; i < strlen($1) - 2; i++) {
        tempString[i] = $1[i + 1];
    }
    *$$ = CreateRecordIO("", tempString, "");
}

void print_ID(Record **$$, ID_t $1) {
    checkVarScope($1);
    str prefix = checkPrefix(getVarType($1));
    *$$ = CreateRecordIO("", prefix, $1);
}

void INPUT_toInput(Record **$$, Record *$3) {
    char *temp[] = {"scanf(\"", $3->IOPrefix, "\",", $3->IOSufix, ");"};
    *$$ = CreateRecord(cat(temp, 5));
};

void ID_toInput(Record **$$, ID_t $1, Record *$3) {
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
    // TODO: O que aconteceria se getvartype é null?
    // type try_get = getVarType($1);

    // TODO: Make this better, tá meio improvisado:
    str prefix = checkPrefix(getVarType($1));
    check_type_prefix(prefix, $1);

    char *tmpInputPrefix[] = {checkPrefix(getVarType($1)), " ", $3->IOPrefix};
    char *tmpInputSufix[] = {"&", $1, ",", $3->IOSufix};
    *$$ = CreateRecordIO("", cat(tmpInputPrefix, 3), cat(tmpInputSufix, 4));
};

void input_ID(Record **$$, ID_t $1) {
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
    str prefix = checkPrefix(getVarType($1));
    str tmpInputSufix[] = {"&", $1};
    *$$ = CreateRecordIO("", prefix, cat(tmpInputSufix, 2));
}
