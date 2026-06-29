#include "../../record.h"
#include "../../symbol_table.h"
#include "../semantics.h"
#include <stdio.h>

// arr : [[u_int16; 1]; 1] = ...
// arr[1][1] u_int16
void VarTyped_ID_Type(Record** $$, ID_t ID, TypeRec* Type) {
    // for (int i = 1; i < Type->size; ++i) {
    //     c_code temp2[] = {code, "[", Type->size, "]"};
    //     code = cat(temp2, 2);
    // }

    SymbolInfo* typeInTypeTable = lookup_symbol(typeTable, Type->type)->info;

    // Type *should* be created, if it isn't, the program should
    // have already crashed.
    if (typeInTypeTable == NULL) {
        printf("This should never happen; if it did, panic.");
    }

    c_code code = "";
    while (typeInTypeTable->isArrayOf != NULL) {
        char arraySize[20];
        sprintf(arraySize, "%lld", typeInTypeTable->size);

        c_code temp[] = {code, "[", arraySize, "]"};
        code = cat(temp, 4);
        typeInTypeTable = lookup_symbol(typeTable, typeInTypeTable->isArrayOf)->info;
    }

    // When it finally gets to the root type of the array
    // Or when it is a root type
    c_code temp[] = {Type->c_code, " ", ID, code};
    code = cat(temp, 4);

    *$$ = CreateRecordVarTyped(code, Type->type, ID);
}
