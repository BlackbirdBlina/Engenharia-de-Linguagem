#include "semantics.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

ScopeStack *scopeStack;
SymbolTable *varTable;
SymbolTable *typeTable;
SymbolTable *funcTable;

/* Custom Functions */
void p(const char c[]) { printf("%s\n", c); }

void np(const char c[]) { printf("%s -> ", c); }

char *cat(char **strings, int qnt) {
    int tam = 0;
    for (int i = 0; i < qnt; i++) {
        if (strings[i] != NULL) {
            tam += strlen(strings[i]);
        }
    }
    tam++;
    char *output = malloc(tam * sizeof(char));
    if (!output) {
        exit(0);
    }
    output[0] = '\0';
    for (int i = 0; i < qnt; i++) {
        strcat(output, strings[i]);
    }
    return output;
}

char *forCount() {
    static int forCounts = 0;
    char *text = malloc(sizeof(char) * 12);
    snprintf(text, sizeof(text), "%d", forCounts++);
    return text;
}

char *whileCount() {
    static int whileCounts = 0;
    char *text = malloc(sizeof(char) * 12);
    snprintf(text, sizeof(text), "%d", whileCounts++);
    return text;
}
char *ifCount() {
    static int ifCounts = 0;
    char *text = malloc(sizeof(char) * 12);
    snprintf(text, sizeof(text), "%d", ifCounts++);
    return text;
}

char *elseCount() {
    static int elseCounts = 0;
    char *text = malloc(sizeof(char) * 12);
    snprintf(text, sizeof(text), "%d", elseCounts++);
    return text;
}

char *endIfCount() {
    static int endifCounts = 0;
    char *text = malloc(sizeof(char) * 12);
    snprintf(text, sizeof(text), "%d", endifCounts++);
    return text;
}
ScopeNode *GenerateScope() {
    static int scopeCount = 1;
    char *scopeName = malloc(sizeof(char) * 14);
    snprintf(scopeName, sizeof(scopeName), "S#%d", scopeCount++);
    return CreateScope(scopeName);
}
void InitializeScopeStack() {
    scopeStack = CreateStack();
    PushScope(scopeStack, CreateScope("GLOBAL"));
}
void InitializeFuncTable() { funcTable = create_table(); }

void InitializeVarTable() { varTable = create_table(); }
void InitializeTypeTable() {
    typeTable = create_table();

    const char *conversions_s_bool[] = {};
    insert_symbol(typeTable, bool_,
                  alloc_type_type(bool_, conversions_s_bool, 0));

    const char *conversions_s_int16[] = {s_int32, s_int64, float32, float64};
    insert_symbol(typeTable, s_int16,
                  alloc_type_type(s_int16, conversions_s_int16, 4));

    const char *conversions_s_int32[] = {s_int64, float64};
    insert_symbol(typeTable, s_int32,
                  alloc_type_type(s_int32, conversions_s_int32, 2));

    const char *conversions_s_int64[] = {};
    insert_symbol(typeTable, s_int64,
                  alloc_type_type(s_int64, conversions_s_int64, 0));

    const char *conversions_u_int16[] = {u_int32, u_int64, s_int32, float64};
    insert_symbol(typeTable, u_int16,
                  alloc_type_type(u_int16, conversions_u_int16, 4));

    const char *conversions_u_int32[] = {u_int64, s_int64};
    insert_symbol(typeTable, u_int32,
                  alloc_type_type(u_int32, conversions_u_int32, 2));

    const char *conversions_u_int64[] = {};
    insert_symbol(typeTable, u_int64,
                  alloc_type_type(u_int64, conversions_u_int64, 0));

    const char *conversions_float32[] = {float64};
    insert_symbol(typeTable, float32,
                  alloc_type_type(float32, conversions_float32, 1));

    const char *conversions_float64[] = {};
    insert_symbol(typeTable, float64,
                  alloc_type_type(float64, conversions_float64, 0));

    const char *conversions_char[] = {};
    insert_symbol(typeTable, char_,
                  alloc_type_type(char_, conversions_char, 0));

    const char *conversions_literal_int[] = {
        u_int16, u_int32, u_int64, s_int16, s_int32, s_int64, float32, float64};
    insert_symbol(typeTable, literal_int,
                  alloc_type_type(literal_int, conversions_literal_int, 8));

    const char *conversions_literal_float[] = {float32, float64};
    insert_symbol(typeTable, literal_float,
                  alloc_type_type(literal_float, conversions_literal_float, 2));

    const char *conversions_void[] = {};
    insert_symbol(typeTable, void_,
                  alloc_type_type(void_, conversions_void, 0));
}

char *checkTypeCompatibility(char *type1, char *type2) {
    // Returns null
    // If the types don't exist
    if (!type1 || !type2) {
        return NULL;
    }

    // If they are the same
    if (strcmp(type1, type2) == 0) {
        return type1;
    }

    // Find
    SymbolNode *type1Node = lookup_symbol(typeTable, type1);
    SymbolNode *type2Node = lookup_symbol(typeTable, type2);
    if (!type1Node || !type2Node) {
        return NULL;
    }

    // Check the conversions list:
    for (int i = 0; i < type1Node->info->conversionsQnt; i++) {
        if (strcmp(type1Node->info->conversions[i], type2) == 0) {
            return type2;
        }
    }
    for (int i = 0; i < type2Node->info->conversionsQnt; i++) {
        if (strcmp(type2Node->info->conversions[i], type1) == 0) {
            return type1;
        }
    }

    return NULL;
}

void checkVarScope(ID_t varName) {
    SymbolNode *var = search_var_in_varTable(varName);
    if (var) {
        if (!FindScope(scopeStack, var->info->scope)) {
            printf("ERROR: Variable  \"%s\" out of scope\n", varName);
            exit(1);
        }
    } else {
        printf("ERROR: Variable \"%s\" not declared\n", varName);
        exit(1);
    }
}

type getVarType(ID_t var) {
    SymbolNode *tabled_var = search_var_in_varTable(var);
    if (tabled_var != NULL) {
        return tabled_var->info->type;
    } else {
        return NULL;
    }
}
ASSIGN getVarAssign(ID_t var) {
    SymbolNode *tabled_var = search_var_in_varTable(var);
    if (tabled_var != NULL) {
        return tabled_var->info->assign;
    } else {
        printf("ERROR: The variable %s has not a assign", var);
        exit(1);
    }
}
str getCurrentScopeName() { return scopeStack->top->scopeName; }
void store_var_in_varTable(ID_t varID, type type, ASSIGN assign) {
    char *tempVarAndScope[] = {varID, getCurrentScopeName()};
    insert_symbol(varTable, cat(tempVarAndScope, 2),
                  alloc_type_var(type, getCurrentScopeName(), assign));
}
void store_func_in_funcTable(ID_t funcID, LinkedList *paramsTypes,
                             type returnType) {
    insert_symbol(funcTable, funcID, alloc_type_func(returnType, paramsTypes));
}
SymbolNode *search_var_in_varTable(ID_t varID) {
    ScopeNode *auxScope = scopeStack->top;
    SymbolNode *var;
    while (auxScope) {
        char *tempVarAndScope[] = {varID, auxScope->scopeName};
        var = lookup_symbol(varTable, cat(tempVarAndScope, 2));
        if (var) {
            return var;
        }
        auxScope = auxScope->next;
    }
    return NULL;
}
SymbolNode *search_func_in_funcTable(ID_t funcID) {
    return lookup_symbol(funcTable, funcID);
}
SymbolNode *search_var_in_currentScope(ID_t varID) {
    char *tempVarAndScope[] = {varID, getCurrentScopeName()};
    return lookup_symbol(varTable, cat(tempVarAndScope, 2));
}
