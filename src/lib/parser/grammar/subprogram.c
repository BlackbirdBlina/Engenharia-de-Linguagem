#include "../../record.h"
#include "../semantics.h"
#include "../types.h"
#include <stdio.h>
#include <stdlib.h>

typedef enum {
    FUNCTION_t,
    PURE_FUNCTION_t,
    PROCEDURE_t
} SUBPROGRAM_TYPE;

void checkReturn(SUBPROGRAM_TYPE subType, str ID, type ScopeReturnType, type Type) {
    switch (subType) {
        case (FUNCTION_t): {
                             if (!checkTypeCompatibility(ScopeReturnType, Type)) {
                                 printf("ERROR: \"%s\" returns '%s' but requires '%s'\n",
                                         ID, ScopeReturnType, Type);
                                 exit(1);
                             }
                             break;
                         }
        case (PURE_FUNCTION_t): {
                                  if (!checkTypeCompatibility(Type, ScopeReturnType)) {
                                      printf("ERROR: pure \"%s\" returns '%s' but requires '%s'\n",
                                              ID, ScopeReturnType, Type);
                                      exit(1);
                                  }
                              }
        case (PROCEDURE_t): {
                              if (!checkTypeCompatibility(ScopeReturnType, Type) && ScopeReturnType) {
                                  printf("ERROR: procedure with a return");
                                  exit(1);
                              }
                          }
    }

}

void FUNCTION_Decl(Record **$$, ID_t ID, Record *Params, Record *Type,
        Record *Scope) {
    char *temp[] = {Type->code, " ", ID, "(", Params->code, ")", Scope->code};

    checkReturn(FUNCTION_t, ID, Scope->returnType, Type->type);

    *$$ = CreateRecordFunc(cat(temp, 7), Params->paramsTypes, Type->type);
    store_func_in_funcTable(ID, Params->paramsTypes, Type->type);
}

void PURE_FUNCTION_Decl(Record **$$, ID_t ID, Record *Params, Record *Type,
        Record *Scope) {
    char *temp[] = {Type->code, " ", ID, "(", Params->code, ")", Scope->code};
    *$$ = CreateRecordFunc(cat(temp, 7), Params->paramsTypes, Type->type);

    checkReturn(PURE_FUNCTION_t, ID, Scope->returnType, Type->type);

    store_func_in_funcTable(ID, Params->paramsTypes, Type->type);
}

void PROCEDURE_Decl(Record **$$, ID_t ID, Record *Params, Record *Scope) {
    char *temp[] = {"void", " ", ID, "(", Params->code, ")", Scope->code};
    *$$ = CreateRecordFunc(cat(temp, 7), Params->paramsTypes, "");

    checkReturn(PROCEDURE_t, ID, Scope->returnType, void_);

    store_func_in_funcTable(ID, Params->paramsTypes, void_);
}
