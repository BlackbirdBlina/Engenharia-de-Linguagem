#ifndef SEMANTICS
#define SEMANTICS

#include "../record.h"
#include "../scope_stack.h"
#include "../symbol_table.h"

extern ScopeStack *scopeStack;
extern SymbolTable *varTable;
extern SymbolTable *typeTable;
extern SymbolTable *funcTable;

typedef char* id;

/* Custom Functions */
void p(const char string[]);
void np(const char string[]);
void InitializeVarTable();
void InitializeTypeTable();
ScopeNode *GenerateScope();
char *cat(char **, int);
char *whileCount();
char *forCount();
char *checkTypeCompatibility(char *, char *);
void checkVarScope(char *);
char *getVarType(id);

#endif
