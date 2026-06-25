#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>
#include "scope_stack.h"

ScopeStack* CreateStack(){
    ScopeStack* stack= malloc(sizeof(ScopeStack));
    if(!stack){
        return NULL;
    }
    stack->top=NULL;
    stack->qnt=0;
    return stack;
}
ScopeNode* CreateScope(char* scopeName){
    ScopeNode* scope=malloc(sizeof(ScopeNode));
    if(!scope){
        return NULL;
    }
    scope->scopeName=scopeName;
    scope->next=NULL;
    return scope;
}
void FreeScopeNode(ScopeNode* scopeNode){
    if(scopeNode){
        free(scopeNode->scopeName);
        free(scopeNode);
    }
}
void PushScope(ScopeStack* stack, ScopeNode* node){
    if (!stack||!node){
        return;
    }
    node->next=stack->top;
    stack->top=node;
    stack->qnt++;
}

void PopScope(ScopeStack* stack){
    if(!stack->top){
        return;
    }
    ScopeNode* temp=stack->top->next;
    FreeScopeNode(stack->top);
    stack->top=temp;
    stack->qnt--;

}

bool FindScope(ScopeStack* stack, char* scopeName){
    ScopeNode* search=stack->top;
    while(search){
        if(strcmp(search->scopeName,scopeName)==0){
            return true;
        }
        search=search->next;
    }
    return false;
}