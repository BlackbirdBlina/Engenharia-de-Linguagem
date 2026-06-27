#include "../../record.h"
#include "../semantics.h"
#include "../types.h"
#include <stdio.h>
#include <stdlib.h>

typedef enum { FUNCTION_t, PURE_FUNCTION_t, PROCEDURE_t } SUBPROGRAM_TYPE;

type checkParamType(ID_t funcID, LinkedList *paramsTypes) {
    if (!funcID || !paramsTypes) {
        printf("Bad use of check_params_types_on_subprogram_call");
        exit(1);
        return NULL;
    }
    SymbolNode *func1 = search_func_in_funcTable(funcID);
    if (!func1) {
        printf("ERROR: The subprogram %s was not declared", funcID);
        exit(1);
        return NULL;
    }
    if (func1->info->typeParams->size != paramsTypes->size) {
        printf("ERROR: The params used to call %s are not compatibles with "
               "your definition",
               funcID);
        exit(1);
        return NULL;
    }
    NodeInfo *auxType1 = func1->info->typeParams->start;
    NodeInfo *auxType2 = paramsTypes->start;
    for (int i = 0; i < func1->info->typeParams->size; i++) {
        if (!checkTypeCompatibility(auxType1->content, auxType2->content)) {
            printf("ERROR: The params used to call %s are not compatibles with "
                   "your definition",
                   funcID);
            exit(1);
            return NULL;
        }
        auxType1 = auxType1->next;
        auxType2 = auxType2->next;
    }
    return func1->info->type;
}

void checkReturn(SUBPROGRAM_TYPE subType, str ID, type ScopeReturnType,
                 type Type) {
    switch (subType) {
    case (FUNCTION_t): {
        if (!checkTypeCompatibility(ScopeReturnType, Type)) {
            printf("ERROR: \"%s\" returns '%s' but requires '%s'\n", ID,
                   ScopeReturnType, Type);
            exit(1);
        }
        break;
    }
    case (PURE_FUNCTION_t): {
        if (!checkTypeCompatibility(Type, ScopeReturnType)) {
            printf("ERROR: pure \"%s\" returns '%s' but requires '%s'\n", ID,
                   ScopeReturnType, Type);
            exit(1);
        }
    }
    case (PROCEDURE_t): {
        if (!checkTypeCompatibility(ScopeReturnType, Type) && ScopeReturnType) {
            printf("ERROR: procedure with a return\n");
            exit(1);
        }
    }
    }
}

void FUNCTION_Decl(Record **$$, ID_t ID, Record *Params, Record *Type,
                   Record *Scope) {
    checkReturn(FUNCTION_t, ID, Scope->returnType, Type->type);

    char *temp[] = {Type->code, " ", ID, "(", Params->code, ")", Scope->code};
    *$$ = CreateRecordFunc(cat(temp, 7), Params->paramsTypes, Type->type);

    store_func_in_funcTable(ID, Params->paramsTypes, Type->type);
}

void PURE_FUNCTION_Decl(Record **$$, ID_t ID, Record *Params, Record *Type,
                        Record *Scope) {
    checkReturn(PURE_FUNCTION_t, ID, Scope->returnType, Type->type);

    char *temp[] = {Type->code, " ", ID, "(", Params->code, ")", Scope->code};
    *$$ = CreateRecordFunc(cat(temp, 7), Params->paramsTypes, Type->type);
    store_func_in_funcTable(ID, Params->paramsTypes, Type->type);
}

void PROCEDURE_Decl(Record **$$, ID_t ID, Record *Params, Record *Scope) {
    checkReturn(PROCEDURE_t, ID, Scope->returnType, void_);

    char *temp[] = {"void", " ", ID, "(", Params->code, ")", Scope->code};
    *$$ = CreateRecordFunc(cat(temp, 7), Params->paramsTypes, "");

    store_func_in_funcTable(ID, Params->paramsTypes, void_);
}

void VarTypedList_Chain(Record **$$, Record *VarTyped, Record *VarTypedList) {
    char *temp[] = {VarTyped->code, ",", VarTypedList->code};
    PushElement(VarTypedList->paramsTypes, CreateNodeInfo(VarTyped->type));
    *$$ = CreateRecordFuncParams(cat(temp, 3), VarTypedList->paramsTypes);
}

void VarTypedList_Single(Record **$$, Record *VarTyped) {
    LinkedList *paramsTypes = CreateLinkedList();
    PushElement(paramsTypes, CreateNodeInfo(VarTyped->type));
    *$$ = CreateRecordFuncParams(VarTyped->code, paramsTypes);
}
