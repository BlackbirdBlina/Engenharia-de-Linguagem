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

ScopeNode *GenerateScope() {
    static int scopeCount = 1;
    char *scopeName = malloc(sizeof(char) * 14);
    snprintf(scopeName, sizeof(scopeName), "S#%d", scopeCount++);
    return CreateScope(scopeName);
}

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

void checkVarScope(char *varName) {
    SymbolNode *var = lookup_symbol(varTable, varName);
    if (var) {
        if (!FindScope(scopeStack, var->info->scope)) {
            printf("Variavel %s Fora de escopo\n", varName);
            exit(1);
        }
    } else {
        printf("Variável \"%s\" não declarada\n", varName);
        exit(1);
    }
}

type getVarType(ID_t var) {
    SymbolNode *tabled_var = lookup_symbol(varTable, var);
    if (tabled_var != NULL) {
        return tabled_var->info->type;
    } else {
        return NULL;
    }
}
