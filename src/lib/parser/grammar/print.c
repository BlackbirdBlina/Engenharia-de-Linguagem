#include "../../record.h"
#include "../../symbol_table.h"
#include "../semantics.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef char *str;
// TODO: Falta adicionar o char* (acho que é o nosso string?)
// TODO: BOOL EM C FICA COMO??
// TODO: ACHO QUE FALTA IMPLEMENTAR O U_SIZE E S_SIZE

str checkPrefix(type t) {
    if (strcmp(t, bool_) == 0)
        return "%d";
    if (strcmp(t, s_int16) == 0)
        return "%d";
    if (strcmp(t, s_int32) == 0)
        return "%d";
    if (strcmp(t, s_int64) == 0)
        return "%l";
    if (strcmp(t, s_size) == 0)
        return "%l";
    if (strcmp(t, u_int16) == 0)
        return "%d";
    if (strcmp(t, u_int32) == 0)
        return "%d";
    if (strcmp(t, u_int64) == 0)
        return "%lu";
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

// TODO: Verificar se as variáveis existem
void PRINT_toPrint(Record **$$, Record *$3) {
    // Quando tem prefixo, com vírgula
    if (strcmp($3->printSufix, "") != 0) {
        char *temp[] = {"printf(\"", $3->printPrefix, "\",", $3->printSufix,
                        ");"};
        *$$ = CreateRecord(cat(temp, 5));
    }
    // Quando não tem, sem vírgula
    else {
        char *temp[] = {"printf(\"", $3->printPrefix, "\");"};
        *$$ = CreateRecord(cat(temp, 3));
    }
};

void check_type_prefix(str prefix, ID_t $1) {

    // If the type for the prefix is not predictable:
    if (prefix == NULL) {
        printf("ERROR: \"%s\"'s type '%s' is not printable\n", $1,
               getVarType($1));
        exit(1);
    }
}

void ID_toPrint(Record **$$, ID_t $1, Record *$3) {
    // TODO: O que aconteceria se getvartype é null?
    // type try_get = getVarType($1);

    // TODO: Make this better, tá meio improvisado:
    str prefix = checkPrefix(getVarType($1));
    check_type_prefix(prefix, $1);

    char *tmpPrintPrefix[] = {checkPrefix(getVarType($1)), $3->printPrefix};
    char *tmpPrintSuffix[] = {$1, ",", $3->printSufix};
    *$$ = CreateRecordPrint("", cat(tmpPrintPrefix, 2), cat(tmpPrintPrefix, 3));
};

void VALUE_STRING_toPrint(Record **$$, VALUE_STRING_t $1, Record *$3) {
    char *tempString = malloc(sizeof($1) - 2);
    for (int i = 0; i < strlen($1) - 2; i++) {
        tempString[i] = $1[i + 1];
    }
    char *tempprintPrefix[] = {tempString, $3->printPrefix};
    *$$ = CreateRecordPrint("", cat(tempprintPrefix, 2), $3->printSufix);
}

void print_VALUE_STRING(Record **$$, VALUE_STRING_t $1) {

    char *tempString = malloc(sizeof($1) - 2);
    for (int i = 0; i < strlen($1) - 2; i++) {
        tempString[i] = $1[i + 1];
    }
    *$$ = CreateRecordPrint("", tempString, "");
}

void print_ID(Record **$$, ID_t $1) {
    str prefix = checkPrefix(getVarType($1));
    *$$ = CreateRecordPrint("", prefix, $1);
}
