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


// TODO: Verificar se as variáveis existem
void INPUT_toInput(Record **$$, Record *$3) {    
    char *temp[] = {"scanf(\"", $3->IOPrefix, "\",", $3->IOSufix,");"};
    *$$ = CreateRecord(cat(temp, 5));
};

void ID_toInput(Record **$$, ID_t $1, Record *$3) {
    checkVarScope($1);
    // TODO: O que aconteceria se getvartype é null?
    // type try_get = getVarType($1);

    // TODO: Make this better, tá meio improvisado:
    str prefix = checkPrefix(getVarType($1));
    check_type_prefix(prefix, $1);

    char *tmpInputPrefix[] = {checkPrefix(getVarType($1))," ",$3->IOPrefix};
    char *tmpInputSufix[] = {"&",$1, ",", $3->IOSufix};
    *$$ = CreateRecordIO("", cat(tmpInputPrefix, 3), cat(tmpInputSufix, 4));
};

void input_ID(Record **$$, ID_t $1) {
    checkVarScope($1);
    str prefix = checkPrefix(getVarType($1));
    str tmpInputSufix[]={"&",$1};
    *$$ = CreateRecordIO("", prefix, cat(tmpInputSufix,2));
}