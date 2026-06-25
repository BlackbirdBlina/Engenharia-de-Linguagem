#ifndef SCOPE_STACK
#define SCOPE_STACK

typedef struct ScopeNode
{
    char* scopeName;
    struct ScopeNode* next;
} ScopeNode;

typedef struct ScopeStack
{
    ScopeNode* top;
    int qnt;
} ScopeStack;

ScopeStack* CreateStack();
ScopeNode* CreateScope(char* scopeName);
void PushScope(ScopeStack* stack,ScopeNode* scopeNode);
void PopScope(ScopeStack* stack);
void FreeScopeNode(ScopeNode* ScopeNode);
bool FindScope(ScopeStack* stack,char* scopeName);



#endif
