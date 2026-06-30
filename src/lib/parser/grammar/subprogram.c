#include "../../record.h"
#include "../parser.h"
#include "../semantics.h"
#include "../types.h"
#include <stdio.h>
#include <stdlib.h>

typedef enum {
    FUNCTION_t,
    PURE_FUNCTION_t,
    PROCEDURE_t
} SUBPROGRAM_TYPE;

type checkParamType(ID_t funcID, LinkedList* paramsTypes) {
    if (!funcID || !paramsTypes) {
        printf("Bad use of check_params_types_on_subprogram_call");
        exit(1);
        return NULL;
    }
    SymbolNode* func1 = search_func_in_funcTable(funcID);
    if (!func1) {
        printf("ERROR Line %d: The subprogram \"%s\" was not declared\n",
               yylineno, funcID);
        exit(1);
        return NULL;
    }
    if (func1->info->typeParams->size != paramsTypes->size) {
        printf("ERROR Line %d: Subprogram \"%s\" expects different parameters\n",
               yylineno, funcID);
        exit(1);
        return NULL;
    }
    NodeInfo* auxType1 = func1->info->typeParams->start;
    NodeInfo* auxType2 = paramsTypes->start;

    for (int i = 0; i < func1->info->typeParams->size; i++) {
        if (!checkTypeCompat(auxType1->content, auxType2->content, RIGHT_LEFT)) {
            printf("ERROR Line %d: Subprogram \"%s\" expects diferent parameters\n",
                   yylineno, funcID);
            exit(1);
            return NULL;
        }
        auxType1 = auxType1->next;
        auxType2 = auxType2->next;
    }
    return func1->info->type;
}

void checkReturn(SUBPROGRAM_TYPE subType, str ID, type ScopeReturnType, type Type) {
    switch (subType) {
    case (FUNCTION_t): {
        if (checkTypeCompat(Type, ScopeReturnType, RIGHT_LEFT) == NULL) {
            printf("ERROR Line %d: \"%s\" returns '%s' but requires '%s'\n",
                   yylineno, ID, ScopeReturnType, Type);
            exit(1);
        }
        break;
    }

    case (PURE_FUNCTION_t): {
        if (checkTypeCompat(Type, ScopeReturnType, RIGHT_LEFT) == NULL) {
            printf("ERROR Line %d: pure \"%s\" returns '%s' but requires '%s'\n",
                   yylineno, ID, ScopeReturnType, Type);
            exit(1);
        }
        break;
    }
    case (PROCEDURE_t): {
        if (checkTypeCompat(Type, ScopeReturnType, BOTH) == NULL && ScopeReturnType) {
            printf("ERROR Line %d: procedure with a return\n",
                   yylineno);
            exit(1);
        }
        break;
    }
    }
}

void SUBPROGRAM_PREDecl( ID_t ID, Record* Params, TypeRec* Type){
    store_func_in_funcTable(ID, Params->paramsTypes, Type->type);
}
void PROCEDURE_PREDecl( ID_t ID, Record* Params){
    store_func_in_funcTable(ID, Params->paramsTypes, void_);
}
void FUNCTION_Decl(Record** $$, ID_t ID, Record* Params, TypeRec* Type, Record* Scope) {
    checkReturn(FUNCTION_t, ID, Scope->returnType, Type->type);
    char* temp[] = {Type->c_code, " ", ID, "(", Params->code, ")", Scope->code};
    *$$ = CreateRecordFunc(cat(temp, 7), Params->paramsTypes, Type->type);
}

void PURE_FUNCTION_Decl(Record** $$, ID_t ID, Record* Params, TypeRec* Type, Record* Scope) {
    checkReturn(PURE_FUNCTION_t, ID, Scope->returnType, Type->type);
    char* temp[] = {Type->c_code, " ", ID, "(", Params->code, ")", Scope->code};
    *$$ = CreateRecordFunc(cat(temp, 7), Params->paramsTypes, Type->type);
}

void PROCEDURE_Decl(Record** $$, ID_t ID, Record* Params, Record* Scope) {
    checkReturn(PROCEDURE_t, ID, Scope->returnType, void_);
    char* temp[] = {"void", " ", ID, "(", Params->code, ")", Scope->code};
    *$$ = CreateRecordFunc(cat(temp, 7), Params->paramsTypes, "");
}

void VarTypedList_Chain(Record** $$, Record* VarTyped, Record* VarTypedList) {
    char* temp[] = {VarTyped->code, ",", VarTypedList->code};
    store_var_in_varTable(VarTyped->id, VarTyped->type, MUT);
    PushElement(VarTypedList->paramsTypes, CreateNodeInfo(VarTyped->type));
    *$$ = CreateRecordFuncParams(cat(temp, 3), VarTypedList->paramsTypes);
}

void VarTypedList_Single(Record** $$, Record* VarTyped) {
    LinkedList* paramsTypes = CreateLinkedList();
    store_var_in_varTable(VarTyped->id, VarTyped->type, MUT);
    PushElement(paramsTypes, CreateNodeInfo(VarTyped->type));
    *$$ = CreateRecordFuncParams(VarTyped->code, paramsTypes);
}
