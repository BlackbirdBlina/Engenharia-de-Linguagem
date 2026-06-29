#ifndef SEMANTICS
#define SEMANTICS

#include "../linked_list.h"
#include "../scope_stack.h"
#include "../symbol_table.h"
#include "types.h"

typedef enum compatDirection {
    LEFT_RIGHT,
    RIGHT_LEFT,
    BOTH,
} compatDirection;

extern ScopeStack* scopeStack;
extern SymbolTable* varTable;
extern SymbolTable* typeTable;
extern SymbolTable* funcTable;

/* Custom Functions */
void p(const char string[]);
void np(const char string[]);
void InitializeScopeStack();
void InitializeTypeTable();
void InitializeFuncTable();
void InitializeVarTable();
ScopeNode* GenerateScope();
char* cat(char**, int);
char* whileCount();
char* forCount();
char* ifCount();
char* elseCount();
char* endIfCount();
char* checkTypeCompat(type, type, compatDirection);
void checkVarScope(ID_t);
type getVarType(ID_t);
ASSIGN getVarAssign(ID_t);
void check_type_prefix(str prefix, ID_t $1);
str getCurrentScopeName();
void store_var_in_varTable(ID_t varID, type type, ASSIGN assign);
void store_func_in_funcTable(ID_t varID, LinkedList* paramsTypes, type returnType);
type check_params_types_on_subprogram_call(ID_t funcID,
                                           LinkedList* paramsTypes);
SymbolNode* search_var_in_varTable(ID_t varID);
SymbolNode* search_var_in_currentScope(ID_t varID);
SymbolNode* search_func_in_funcTable(ID_t funcID);

#endif
