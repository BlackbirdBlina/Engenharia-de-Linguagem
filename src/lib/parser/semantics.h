#ifndef SEMANTICS
#define SEMANTICS

#include "../record.h"
#include "../scope_stack.h"
#include "../symbol_table.h"
#include "../linked_list.h"

extern ScopeStack *scopeStack;
extern SymbolTable *varTable;
extern SymbolTable *typeTable;
extern SymbolTable *funcTable;

typedef char * ID_t;
typedef char* VALUE_STRING_t;
typedef char * str;

/* Custom Functions */
void p(const char string[]);
void np(const char string[]);
void InitializeScopeStack();
void InitializeTypeTable();
void InitializeFuncTable();
void InitializeVarTable();
ScopeNode *GenerateScope();
char *cat(char **, int);
char *whileCount();
char *forCount();
char* ifCount();
char* elseCount();
char* endIfCount();
char *checkTypeCompatibility(char *, char *);
void checkVarScope(ID_t);
type getVarType(ID_t);
str checkPrefix(type t);
void check_type_prefix(str prefix, ID_t $1);
str getCurrentScopeName();
void store_var_in_varTable(ID_t varID,type type);
void store_func_in_funcTable(ID_t varID,LinkedList* paramsTypes,type returnType);
type check_params_types_on_subprogram_call(ID_t funcID,LinkedList* paramsTypes);
SymbolNode* search_var_in_varTable(ID_t varID);
SymbolNode* search_var_in_currentScope(ID_t varID);
SymbolNode* search_func_in_funcTable(ID_t funcID);
#endif
